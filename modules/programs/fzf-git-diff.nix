# inspired by github:nickjj/dotfiles/.local/bin/gd
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.acme = {
    fzf-git-diff = {
      enable = lib.mkEnableOption "fzf-git-diff";
    };
  };

  config = let
    cfg = config.acme.fzf-git-diff;

    # Preview command for gd (file-level diff).
    # GIT_ARGS_STR and SIDE_BY_SIDE are exported shell vars; bash expands them
    # at fzf-command-construction time (double-quoted --preview string).
    # {-1} is an fzf placeholder substituted at preview time.
    filePreviewCmd = ''git diff ''${GIT_ARGS_STR} -- {-1} | delta --width=100 ''${SIDE_BY_SIDE:+--side-by-side}'';

    # Preview command for gl (commit-level diff). {1} = short hash from --oneline.
    commitPreviewCmd = "git show {1} | delta --width=100";

    # Peek binding for gl: open full diff in pager, then return to gl.
    commitPeekCmd = "git show {1} | delta | less -FRX";

    # Meld command: show multiple selected commits in one pager.
    # HASHES is a bash array populated after fzf exits.
    meldCmd = ''git show "''${HASHES[@]}" | delta | less -FRX'';

    gd = pkgs.writeShellApplication {
      name = "gd";
      runtimeInputs = [pkgs.fzf pkgs.git pkgs.delta];
      text = ''
        # Browse git diffs through fzf + delta. Accepts any flags that
        # git diff supports, plus --side (delta only, silently ignored otherwise).
        #
        # Examples:
        #   gd
        #   gd --staged
        #   gd HEAD~1..HEAD
        #   gd --side
        set -o errexit
        set -o pipefail
        set -o nounset

        SIDE_BY_SIDE=""
        GIT_ARGS=()
        for arg in "$@"; do
          if [[ "$arg" == "--side" ]]; then
            SIDE_BY_SIDE=1
          else
            GIT_ARGS+=("$arg")
          fi
        done
        GIT_ARGS+=("--color=always")

        # Join to a plain string for fzf preview (exported so it survives into
        # the double-quoted --preview string where bash expands it).
        # Safe: git diff flags do not contain spaces.
        GIT_ARGS_STR="''${GIT_ARGS[*]}"
        export GIT_ARGS_STR
        export SIDE_BY_SIDE

        git diff --name-only "''${GIT_ARGS[@]}" |
          fzf --ansi \
            --preview "${filePreviewCmd}" \
            --preview-window="right,75%" || true
      '';
    };

    gl = pkgs.writeShellApplication {
      name = "gl";
      runtimeInputs = [pkgs.fzf pkgs.git pkgs.delta gd];
      text = ''
        # Browse git log through fzf + delta.
        # Tab/Shift-Tab: select/deselect commits.
        # Ctrl-P: peek at highlighted commit's full diff in pager, return to gl.
        # Enter:
        #   0 tab-selected → drill into gd file picker for highlighted commit
        #   2+ tab-selected → meld selected commits' diffs in one pager
        #
        # Examples:
        #   gl
        #   gl --all
        #   gl HEAD~20..HEAD
        set -o errexit
        set -o pipefail
        set -o nounset

        SELECTION=$(
          git log --oneline --color=always "$@" |
            fzf --ansi \
              --no-sort \
              --multi \
              --preview "${commitPreviewCmd}" \
              --preview-window="right,70%" \
              --bind "ctrl-p:execute(${commitPeekCmd})" \
              || true
        )

        [[ -z "$SELECTION" ]] && exit 0

        mapfile -t HASHES < <(echo "$SELECTION" | awk '{print $1}')

        if [[ "''${#HASHES[@]}" -eq 1 ]]; then
          gd "''${HASHES[0]}^..''${HASHES[0]}"
        else
          ${meldCmd}
        fi
      '';
    };
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [gd gl];
    };
}

# inspired by github:nickjj/dotfiles/.local/bin/gd
{
  writeShellApplication,
  fzf,
  git,
  delta,
  ...
}:
let
  # Preview command for gd (file-level diff).
  # GIT_ARGS_STR are exported shell vars; bash expands them
  # at fzf-command-construction time (double-quoted --preview string).
  # {-1} is an fzf placeholder substituted at preview time.
  filePreviewCmd = "git diff \${GIT_ARGS_STR} -- {-1} | delta --width=variable";

  # Preview command for gl (commit-level diff). {1} = short hash from --oneline.
  commitPreviewCmd = "git show {1} | delta --width=variable";

  # Peek binding for gl: open full diff in pager, then return to gl.
  commitPeekCmd = "git show {1} | delta | less -FRX";

  gd = writeShellApplication {
    name = "gd";
    runtimeInputs = [
      fzf
      git
      delta
    ];
    text = ''
      # Browse git diffs through fzf + delta. Accepts any flags that
      # git diff supports.
      #
      # Examples:
      #   gd
      #   gd --staged
      #   gd HEAD~1..HEAD
      set -o errexit
      set -o pipefail
      set -o nounset

      GIT_ARGS=()
      for arg in "$@"; do
        GIT_ARGS+=("$arg")
      done
      GIT_ARGS+=("--color=always")

      # Join to a plain string for fzf preview (exported so it survives into
      # the double-quoted --preview string where bash expands it).
      # Safe: git diff flags do not contain spaces.
      GIT_ARGS_STR="''${GIT_ARGS[*]}"
      export GIT_ARGS_STR

      git diff --name-only "''${GIT_ARGS[@]}" |
        fzf --ansi \
          --preview "${filePreviewCmd}" \
          --preview-window="right,75%" || true
    '';
  };

  gl = writeShellApplication {
    name = "gl";
    runtimeInputs = [
      fzf
      git
      delta
      gd
    ];
    text = ''
      # Browse git log through fzf + delta.
      # Tab/Shift-Tab: select/deselect commits.
      # Ctrl-P: peek at highlighted commit's full diff in pager, return to gl.
      # Enter: drill into gd file picker for highlighted commit
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

      gd "''${HASHES[0]}^..''${HASHES[0]}"

    '';
  };
in
{
  inherit gd gl;
}

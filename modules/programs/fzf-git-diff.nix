# inspired by github:nickjj/dotfiles/.local/bin/gd
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.acme = {
    fzf-git-diff.enable = lib.mkEnableOption "fzf-git-diff";
  };

  config = let
    gd = pkgs.writeShellApplication {
      name = "gd";
      runtimeInputs = [pkgs.fzf pkgs.delta];
      text = ''
        # Show and preview git diffs through fzf. Anything you can pass to git diff
        # you can pass to this script. It also supports passing in --side to configure
        # delta to use side-by-side mode.
        #
        # Examples:
        #   gd
        #   gd --staged
        #   gd [any flag that git diff supports]
        set -o errexit
        set -o pipefail
        set -o nounset
        GIT_ARGS=()
        for arg in "$@"; do
            GIT_ARGS+=("$arg")
        done
        GIT_ARGS+=("--color=always")
        git diff --name-only "${"$"}{GIT_ARGS:-}"  |
          fzf --ansi \
            --preview "git diff ${"$"}{GIT_ARGS:-} -- {-1} | delta --width=100" \
            --preview-window="right,75%" || true
      '';
    };
  in
    lib.mkIf config.acme.fzf-git-diff.enable {
      environment.systemPackages = [gd];
    };
}

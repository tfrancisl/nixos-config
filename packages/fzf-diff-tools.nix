# inspired by github:nickjj/dotfiles/.local/bin/gd
{
  writeShellApplication,
  fzf,
  git,
  delta,
  ...
}:
let
  fzfDefaultOpts ="--layout reverse --style full";

  gd = writeShellApplication {
    name = "gd";
    runtimeInputs = [
      fzf
      git
      delta
    ];
    text = ''
      # Browse git diffs through fzf + delta.
      #
      # Examples:
      #   gd
      #   gd --staged
      #   gd HEAD~1..HEAD
      set -o errexit
      set -o pipefail
      set -o nounset

      export FZF_DEFAULT_OPTS="${fzfDefaultOpts}"

      git diff --name-only --color=always "$@" |
      fzf --ansi --bind=ctrl-s:toggle-sort \
          --preview "git diff -- {-1} | delta --width=variable" \
          --preview-window="right,75%" || true
    '';
  };

  gl = writeShellApplication {
    name = "gl";
    runtimeInputs = [
      fzf
      git
      delta
    ];
    text = ''
      # Browse git log with fzf and delta.
      # Enter to view the delta diff for the commit
      #
      # Examples:
      #   gl
      #   gl --all
      #   gl HEAD~20..HEAD
      set -o errexit
      set -o pipefail
      set -o nounset

      export FZF_DEFAULT_OPTS="${fzfDefaultOpts}"

      git log --oneline --color=always "$@" |
      fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
          --bind "ctrl-m:execute:
          echo {} |
          grep -o '[a-f0-9]\{7\}' |
          head -1 | xargs -I % sh -c 'git show % | delta | less -R'"
    '';
  };
in
{
  inherit gd gl;
}

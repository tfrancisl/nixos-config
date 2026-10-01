#!/bin/sh
# Links an extracted darwin-dots release into $HOME, per links.tsv.
#   DOTS       release directory to link from (default: ~/.local/share/acme-dots/current)
#   ACME_REPO  checkout of this repo; "repo" entries link into it when set, so edits land in git
#   --brew     also `brew bundle` the Brewfile
set -eu

DOTS=${DOTS:-$HOME/.local/share/acme-dots/current}
ACME_REPO=${ACME_REPO:-}
brew=0
for arg in "$@"; do
  case $arg in
    --brew) brew=1 ;;
    *) echo "install.sh: unknown argument: $arg" >&2; exit 2 ;;
  esac
done

stamp=$(date +%Y%m%d%H%M%S)
tab=$(printf '\t')
while IFS="$tab" read -r kind target path; do
  case $kind in
    gen) src="$DOTS/files/$path" ;;
    repo)
      if [ -n "$ACME_REPO" ] && [ -e "$ACME_REPO/$path" ]; then
        src="$ACME_REPO/$path"
      else
        src="$DOTS/repo/$path"
      fi
      ;;
    *) echo "install.sh: bad links.tsv entry: $kind" >&2; exit 1 ;;
  esac
  dest="$HOME/$target"
  mkdir -p "$(dirname "$dest")"
  # Same rule as hjem-impure: never clobber a real file, move it aside instead.
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup-$stamp"
    echo "backed up $dest -> $dest.backup-$stamp"
  fi
  ln -sfn "$src" "$dest"
  echo "$dest -> $src"
done < "$DOTS/links.tsv"

if [ "$brew" = 1 ]; then
  brew bundle --file "$DOTS/Brewfile"
fi

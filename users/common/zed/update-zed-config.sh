#!/usr/bin/env bash
# Update zed config from nixos-config user settings
# Usage: update-zed-config [source-file]

set -euo pipefail

# Default source file location
DEFAULT_SOURCE="$HOME/nixos-config/users/$USER/zed/settings.json"
SOURCE="${1:-$DEFAULT_SOURCE}"
DEST="$HOME/.config/zed/settings.json"

# Check if source file exists
if [[ ! -f "$SOURCE" ]]; then
  echo "Error: Source file not found: $SOURCE" >&2
  exit 1
fi

# Ensure destination directory exists
mkdir -p "$(dirname "$DEST")"

# Copy the file
cp "$SOURCE" "$DEST"

echo "Updated zed config from: $SOURCE"
echo "Zed will reload the settings automatically."

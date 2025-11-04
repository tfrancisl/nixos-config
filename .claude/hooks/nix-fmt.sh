#!/usr/bin/env bash
# Auto-format Nix files after Claude makes changes
# Runs after user submits a prompt and Claude completes edits

# Find all modified .nix files (staged or unstaged)
modified_nix_files=$(git diff --name-only HEAD 2>/dev/null | grep '\.nix$')

if [ -n "$modified_nix_files" ]; then
    echo "Formatting modified Nix files with alejandra..."
    echo "$modified_nix_files" | xargs alejandra --quiet 2>/dev/null || true
fi

exit 0

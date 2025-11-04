#!/usr/bin/env bash
# Auto-commit changes after Claude responds
# Generates descriptive commit messages under 80 characters

set -e

cd "$CLAUDE_PROJECT_DIR"

# Check if there are any changes
if git diff --quiet && git diff --cached --quiet; then
    exit 0  # No changes, nothing to commit
fi

# Get list of modified files
MODIFIED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
NUM_FILES=$(echo "$MODIFIED_FILES" | grep -v '^$' | wc -l)

if [[ $NUM_FILES -eq 0 ]]; then
    exit 0  # No changes
fi

# Track if .nix files were modified for later validation
NIX_FILES_MODIFIED=$(echo "$MODIFIED_FILES" | grep -c '\.nix$' || true)

# Generate commit message based on changed files
if [[ $NUM_FILES -eq 1 ]]; then
    # Single file - use filename
    FILE=$(echo "$MODIFIED_FILES" | head -1)
    DIRNAME=$(dirname "$FILE")
    BASENAME=$(basename "$FILE" .nix)

    if [[ "$DIRNAME" == "." ]]; then
        COMMIT_MSG="Update $BASENAME"
    else
        COMMIT_MSG="Update $DIRNAME/$BASENAME"
    fi
else
    # Multiple files - categorize by directory
    if echo "$MODIFIED_FILES" | grep -q "valhalla/hyprland/"; then
        COMMIT_MSG="Update Hyprland configuration"
    elif echo "$MODIFIED_FILES" | grep -q "valhalla/system/"; then
        COMMIT_MSG="Update system configuration"
    elif echo "$MODIFIED_FILES" | grep -q "valhalla/hardware/"; then
        COMMIT_MSG="Update hardware configuration"
    elif echo "$MODIFIED_FILES" | grep -q "valhalla/home/"; then
        COMMIT_MSG="Update user configuration"
    elif echo "$MODIFIED_FILES" | grep -q "\.claude/"; then
        COMMIT_MSG="Update Claude Code configuration"
    elif [[ $NIX_FILES_MODIFIED -gt 0 ]]; then
        COMMIT_MSG="Update Nix configuration ($NUM_FILES files)"
    else
        COMMIT_MSG="Update configuration ($NUM_FILES files)"
    fi
fi

# Ensure message is under 80 chars
if [[ ${#COMMIT_MSG} -gt 79 ]]; then
    COMMIT_MSG="${COMMIT_MSG:0:76}..."
fi

# Stage all changes
git add -A

# Commit with generated message
git commit -m "$COMMIT_MSG" --no-verify 2>/dev/null || {
    echo "⚠️  Commit failed or nothing to commit"
    exit 0
}

echo "✓ Committed: $COMMIT_MSG"

# Run nix flake check if .nix files were modified
if [[ $NIX_FILES_MODIFIED -gt 0 ]]; then
    echo ""
    echo "Running nix flake check (blocking)..."
    if nix flake check --no-warn-dirty 2>&1; then
        echo "✓ Nix flake check passed"
    else
        echo "❌ Nix flake check failed - please review changes"
        exit 1
    fi
fi

exit 0

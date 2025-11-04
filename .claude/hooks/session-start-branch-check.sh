#!/usr/bin/env bash
# Ensures we're working on a non-main branch
# Creates a feature branch if currently on main

set -e

CURRENT_BRANCH=$(git branch --show-current)

if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]]; then
    # Generate branch name with timestamp
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    NEW_BRANCH="claude/work_${TIMESTAMP}"

    echo "⚠️  Currently on main branch. Creating feature branch: $NEW_BRANCH"
    git checkout -b "$NEW_BRANCH"
    echo "✓ Switched to branch: $NEW_BRANCH"
else
    echo "✓ Working on branch: $CURRENT_BRANCH"
fi

exit 0

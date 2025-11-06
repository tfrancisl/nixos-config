# Testing Blocking Nix Flake Checks

## Overview

The auto-commit hook now runs `nix flake check` BEFORE committing. If the check fails, it returns exit code 2, which blocks Claude from continuing until the issue is resolved.

## Test Scenarios

### Scenario 1: Valid Changes (Should Pass)

1. Ask Claude to make a simple, valid change to a .nix file
2. Expected behavior:
   - Hook runs `nix flake check`
   - Check passes
   - Changes are committed
   - Claude continues normally

### Scenario 2: Invalid Syntax (Should Block)

1. Introduce a syntax error in a .nix file (e.g., missing semicolon, unclosed brace)
2. Expected behavior:
   - Hook runs `nix flake check`
   - Check fails with syntax error
   - Hook exits with code 2
   - Error message fed to Claude via stderr
   - NO commit is created
   - Claude sees the error and can fix it

### Scenario 3: Type Error (Should Block)

1. Introduce a type mismatch or undefined variable
2. Expected behavior:
   - Hook runs `nix flake check`
   - Check fails with type error
   - Hook exits with code 2
   - Error shown to Claude
   - NO commit is created
   - Claude can diagnose and fix

### Scenario 4: Non-Nix Changes (Should Skip Check)

1. Modify non-.nix files (e.g., .md, .sh)
2. Expected behavior:
   - Hook detects no .nix files modified
   - Skips flake check
   - Commits changes immediately
   - Claude continues

## Manual Testing

You can test the hook manually:

```bash
# Create test change
echo "# test change" >> flake.nix

# Run the hook directly
CLAUDE_PROJECT_DIR=$(pwd) .claude/hooks/auto-commit.sh

# Check if commit was created
git log -1

# Reset test change
git reset HEAD~1
git checkout flake.nix
```

## Testing Invalid Syntax

```bash
# Introduce syntax error
echo "{ broken syntax" >> machines/valhalla/settings.nix

# Run hook (should block with exit 2)
CLAUDE_PROJECT_DIR=$(pwd) .claude/hooks/auto-commit.sh
echo "Exit code: $?"

# Should output error and exit code 2

# Cleanup
git checkout machines/valhalla/settings.nix
```

## Verification Checklist

- [ ] Hook runs before commit (check script line order)
- [ ] Valid changes commit successfully
- [ ] Invalid syntax blocks commit and shows error
- [ ] Error message is clear and actionable
- [ ] Claude receives the error via stderr
- [ ] No commit is created when blocked
- [ ] Non-.nix files bypass the check

## Hook Execution Flow

```
1. User submits prompt
2. Claude makes changes
3. Stop hook triggers:
   a. nix-fmt.sh runs (formats .nix files)
   b. auto-commit.sh runs:
      - Detects modified files
      - Generates commit message
      - IF .nix files modified:
        * Run nix flake check
        * IF fails: exit 2 (BLOCKS, no commit)
        * IF passes: continue
      - Stage changes (git add -A)
      - Create commit
4. If exit 2: Claude sees error and cannot finish
5. If exit 0: Claude finishes normally
```

## Debugging

If the blocking check doesn't work:

1. Check hook execution in transcript mode
2. Verify exit code: `echo $?` after running hook
3. Check stderr output is properly formatted
4. Ensure timeout (120s) is sufficient for flake check
5. Verify hook permissions: `ls -la .claude/hooks/`

# Claude Code Hooks Reference

Saved from: https://docs.claude.com/en/docs/claude-code/hooks

## Available Hook Types

1. **SessionStart** - Runs when Claude Code starts a new session
2. **SessionEnd** - Runs when a Claude Code session ends
3. **UserPromptSubmit** - Runs when the user submits a prompt, before Claude processes it
4. **PreToolUse** - Runs after Claude creates tool parameters and before processing the tool call
5. **PostToolUse** - Runs immediately after a tool completes successfully
6. **Stop** - Runs when the main Claude Code agent has finished responding
7. **SubagentStop** - Runs when a Claude Code subagent (Task tool call) has finished responding
8. **Notification** - Triggers when Claude needs permission or waits for input
9. **PreCompact** - Executes before context compaction

## Exit Code Behavior

- **Exit 0**: Success; stdout shown in transcript mode
- **Exit 2**: Blocking error; stderr fed to Claude for processing
- **Other codes**: Non-blocking; stderr shown to user, execution continues

## Event-Specific Blocking Behavior

### PreToolUse with exit 2
- Blocks the tool call
- Shows stderr to Claude
- Claude can adjust and retry

### UserPromptSubmit with exit 2
- Blocks prompt processing
- Erases the prompt
- Shows stderr to user only (not Claude)

### Stop/SubagentStop with exit 2
- Blocks Claude from finishing
- Shows stderr to Claude
- Claude must address the issue before continuing
- Can use JSON output with `"decision": "block"` and `reason` field

## Hook Configuration

```json
{
  "hooks": {
    "EventName": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "path/to/script.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## Execution Details

- All matching hooks run in parallel
- Multiple identical hook commands are deduplicated automatically
- Default timeout: 60 seconds (configurable)
- Timeout for one command doesn't affect others

## Best Practices

1. **Security**
   - Never trust input data blindly
   - Quote shell variables: `"$VAR"` not `$VAR`
   - Block path traversal (check for `..`)
   - Use absolute paths for scripts
   - Skip sensitive files (`.env`, `.git/`, keys)

2. **Blocking Checks**
   - Use exit code 2 for validation failures
   - Provide clear error messages in stderr
   - Include actionable remediation steps
   - List affected files when relevant

3. **Performance**
   - Keep hooks fast to avoid blocking workflow
   - Use appropriate timeouts
   - Consider parallel execution

## This Repository's Hooks

### SessionStart Hook
- Script: `.claude/hooks/session-start-branch-check.sh`
- Purpose: Ensures work happens on feature branch (not main)
- Timeout: 10s

### Stop Hooks (sequential)
1. **nix-fmt.sh** (timeout: 30s)
   - Auto-formats modified .nix files with alejandra

2. **auto-commit.sh** (timeout: 120s)
   - Runs `nix flake check` if .nix files modified
   - **Blocks with exit 2** if check fails
   - Only commits if validation passes
   - Generates descriptive commit message (<80 chars)

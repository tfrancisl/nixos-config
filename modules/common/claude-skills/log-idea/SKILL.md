---
name: log-idea
description: Append an idea to .planning/IDEAS.md for future consideration. Use to capture deferred work, experiments, or future scope without interrupting current work.
---

# Log Idea

Capture a future idea in `.planning/IDEAS.md`.

## Steps

### 1. Get the idea text

If the user provided text inline with the command, use it. Otherwise ask: "What's the idea? Add context if useful."

### 2. Format the entry

```
- <idea> — <optional context>
```

Omit the context suffix if none was given.

### 3. Write to IDEAS.md

Walk up from cwd to repo root to find `.planning/IDEAS.md`.

- If the file exists: append the bullet at the end (or after the last bullet in the main `# Ideas` section if sections exist).
- If not: create `.planning/IDEAS.md`:

```markdown
# Ideas

- <idea>
```

### 4. Confirm

Show the user the exact line added.

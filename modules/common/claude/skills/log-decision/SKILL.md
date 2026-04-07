---
name: log-decision
description: Prepend a dated decision entry to .planning/DECISIONS.md. Use when a significant implementation or architectural decision has been made.
---

# Log Decision

Record a decision in `.planning/DECISIONS.md`.

## Steps

### 1. Get the decision text

If the user provided text inline with the command, use it. Otherwise ask: "What was the decision? Include the rationale — why this choice over alternatives."

### 2. Format the entry

```
- YYYY-MM-DD: <decision> — <rationale>
```

Use today's date. One line. Em dash (`—`) separates decision from rationale.

### 3. Write to DECISIONS.md

Walk up from cwd to repo root to find `.planning/DECISIONS.md`.

- If the file exists: insert the new bullet immediately after the `# Decisions` heading (newest-first).
- If not: create `.planning/DECISIONS.md`:

```markdown
# Decisions

- YYYY-MM-DD: <decision> — <rationale>
```

### 4. Confirm

Show the user the exact line added.

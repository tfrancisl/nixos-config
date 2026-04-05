---
name: wrap-up
description: Review the session and log any decisions or ideas to .planning/ before closing. Use at the end of a working session to make sure significant decisions and deferred ideas are captured.
---

# Wrap Up

Review the session and persist anything worth keeping before the context is lost.

## Steps

### 1. Review the session

Scan the conversation for:
- **Decisions**: choices made with real tradeoffs or rationale (implementation approaches, rejected alternatives, constraint discoveries)
- **Ideas**: things that came up but were explicitly deferred ("we could also...", "maybe later...", out-of-scope items)

Ignore small tactical choices with no lasting relevance.

### 2. Draft entries

For each decision, draft:
```
- YYYY-MM-DD: <decision> — <rationale>
```

For each idea, draft:
```
- <idea> — <context from session>
```

Use today's date for all decisions.

### 3. Present to the user

Show the drafted entries grouped as "Decisions" and "Ideas". Ask: "Anything to add, drop, or reword?"

If nothing worth logging was found, say so plainly and stop.

### 4. Write confirmed entries

Once the user confirms (edits accepted or a plain "yes"):
- Prepend each decision to `.planning/DECISIONS.md` (newest-first, after `# Decisions` heading)
- Append each idea to `.planning/IDEAS.md`
- Create either file with its heading if it doesn't exist

### 5. Confirm

List the files written and the count of entries added to each.

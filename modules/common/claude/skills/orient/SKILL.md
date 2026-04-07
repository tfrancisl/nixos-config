---
name: orient
description: Read .planning/ files to load project context at session start. Use when starting a session on a project or when the user wants Claude to understand where the project stands.
---

# Orient

Load project context from `.planning/` files.

## Steps

### 1. Find the planning directory

Walk up from cwd to find `.planning/` (stop at repo root — presence of `.git/`). If not found, tell the user: "No `.planning/` directory found. You can create one with DECISIONS.md and IDEAS.md to track project context."

### 2. Detect format

Check for GSD format: `config.json` present in `.planning/`, or `STATE.md` with `gsd_state_version` in its frontmatter, or numbered phase subdirectories (e.g. `01-*/`).

If GSD format detected: read what you can, then tell the user: "This looks like a GSD project. Run `/migrate-planning` to convert it to the simpler format."

### 3. Read available files

Read whichever exist:
- `.planning/PROJECT.md` — project overview, current milestone, constraints
- `.planning/DECISIONS.md` — decision log
- `.planning/IDEAS.md` — future ideas and deferred scope

### 4. Summarize

Print a concise summary:
- What the project is and current milestone (from PROJECT.md, if present)
- The 5 most recent decisions (from DECISIONS.md, if present)
- Count of ideas (from IDEAS.md, if present)

End with: "Context loaded." Do not create any files.

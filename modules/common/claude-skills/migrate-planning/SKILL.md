---
name: migrate-planning
description: Convert a GSD-format .planning/ directory to the simpler decisions/ideas format. Extracts decisions from STATE.md and deferred items from PROJECT.md/REQUIREMENTS.md, produces DECISIONS.md and IDEAS.md, then archives old GSD files.
---

# Migrate Planning

Convert a GSD `.planning/` directory to the simpler format: `DECISIONS.md`, `IDEAS.md`, and a condensed `PROJECT.md`.

## Steps

### 1. Read all existing planning files

Read every file in `.planning/`:
- `STATE.md` — for the `## Decisions` section and `last_updated` frontmatter field
- `PROJECT.md` — for "What This Is", current milestone, constraints, out-of-scope items
- `REQUIREMENTS.md` — for deferred/out-of-scope requirements
- `ROADMAP.md` — for future milestones not yet started
- Phase directories and files (e.g. `01-*/`) — no content to extract; will be archived

### 2. Write DECISIONS.md

Extract every bullet from STATE.md's `## Decisions` section. Date each entry using `last_updated` from STATE.md's frontmatter if available, otherwise today's date.

Write `.planning/DECISIONS.md`:

```markdown
# Decisions

- YYYY-MM-DD: <decision> — <rationale>
```

Preserve original wording. Newest first if dates vary.

### 3. Write IDEAS.md

Gather future/deferred items from:
- PROJECT.md "Out of Scope" section
- REQUIREMENTS.md items marked v2, deferred, or out of scope
- ROADMAP.md phases/milestones not yet started

Write `.planning/IDEAS.md`:

```markdown
# Ideas

- <item> — <reason/context>
```

### 4. Write condensed PROJECT.md

Produce a new `.planning/PROJECT.md` of ~20 lines max:
- What the project is (1–2 sentences)
- Current milestone and status (1 line)
- Key constraints (bullet list, 3–6 items)

Overwrite the existing PROJECT.md.

### 5. Archive old GSD files

Move to `.planning/archive/`:
- `STATE.md`
- `ROADMAP.md`
- `REQUIREMENTS.md`
- `config.json` (if present)
- All numbered phase directories and their contents

Do NOT archive the new `DECISIONS.md`, `IDEAS.md`, or `PROJECT.md`.

### 6. Advise the user

Print a summary:
- What was created (DECISIONS.md: N decisions, IDEAS.md: N ideas, PROJECT.md: condensed)
- What was archived (list files/dirs moved to `.planning/archive/`)
- Gitignore tip: "To skip tracking the archive: `echo '.planning/archive/' >> .gitignore`"

# Claude Code Principles

*Based on Shrivu Shankar's guide: "How I Use Every Claude Code Feature"*

## Philosophy

### CLAUDE.md as a Forcing Function
- Keep CLAUDE.md concise - it should be a constraint that forces simplification
- Start with **what Claude gets wrong**, then expand from there
- Document only tools/APIs used by 30%+ of scenarios
- If something requires extensive documentation, improve the tooling instead

### Token Budget Awareness
- CLAUDE.md is read on every session - treat it as limited real estate
- Don't embed large documentation files with @-mentions - reference them instead
- For complex usage or rare errors, point to external docs: `"For FooBarError, see path/to/docs.md"`
- A fresh session with CLAUDE.md typically costs ~20% of 200k token budget

### Better Tooling Over Documentation
**Anti-pattern**: Complex CLI with pages of documentation
**Better**: Simple wrapper with intuitive API + concise docs

Example:
```bash
# Don't document this complexity:
kubectl get pods -n production --field-selector status.phase=Running -o json | jq '.items[].metadata.name'

# Instead, create this wrapper and document it:
k8s-list-running production
```

## Configuration Patterns

### Guardrails Over Comprehensiveness
- Provide alternatives, not just constraints
- **Bad**: "Never use --foo-bar flag"
- **Good**: "Never use --foo-bar flag, prefer --baz for safety. For complex cases see docs.md"

### Hook Strategy
Use hooks for:
- Repetitive post-processing (formatting, linting)
- Validation that catches common mistakes
- Setting up environment state

Hooks should be fast and non-blocking - prefer `|| true` to prevent blocking workflow.

### Skills vs Inline Work
- Create skills for repeated specialized workflows
- Keep skills focused on single concerns
- Skills = reusable, parameterized workflows
- Hooks = automated reactions to events

## Anti-Patterns

1. **Documentation bloat**: Embedding entire docs in CLAUDE.md
2. **Negative-only constraints**: Saying what NOT to do without alternatives
3. **Over-documentation**: Writing paragraphs about bad tooling instead of fixing tools
4. **Everything in CLAUDE.md**: Treating it as comprehensive documentation

## This Repository

Applying these principles:
- CLAUDE.md focuses on common mistakes (unfree packages, module structure)
- External references to nix manpages instead of embedding syntax guides
- Hook for auto-formatting (repetitive task)
- Architecture criticism points to real issues, not generic best practices

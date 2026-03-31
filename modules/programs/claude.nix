{
  config,
  lib,
  claude-code,
  ...
}: let
  cfg = config.acme.claude-code;
  inherit (config.acme.core) username;
in {
  options.acme = {
    claude-code.enable = lib.mkEnableOption "Claude Code";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      claude-code # Uses overlay from sadjow/claude-code-nix instead of nixpkgs
    ];
    hjem.users.${username} = {
      files = {
        ".claude/CLAUDE.md".text = ''
          ## General tone and terminology
          - Abbreviations of common words are acceptable as long as they are clear.
          - Application or project specific jargon can be acceptable, as long as its documented.

          ## Approach
          - Think before acting. Read existing files before writing code.
          - Be concise in output but thorough in reasoning.
          - Prefer editing over rewriting whole files.
          - Do not re-read files you have already read unless the file may have changed.
          - Test your code before declaring done.
          - No sycophantic openers or closing fluff.
          - Keep solutions simple and direct. No over-engineering.
          - If unsure: say so. Never guess or invent file paths.
          - User instructions always override this file.

          ## Efficiency
          - Read before writing. Understand the problem before coding.
          - No redundant file reads. Read each file once.
          - One focused coding pass. Avoid write-delete-rewrite cycles.
          - Test once, fix if needed, verify once. No unnecessary iterations.
          - Budget: 50 tool calls maximum. Work efficiently.

          ## Project tracking
          - When a significant implementation or architectural decision is made, suggest logging it: "Worth running `/log-decision` on that?"
          - When a good idea comes up but is explicitly deferred, suggest: "Want to `/log-idea` that for later?"
          - Don't suggest this for every small choice — only decisions with real tradeoffs or rationale worth preserving.

        '';
        ".claude/skills/git-guardrails/scripts/block-dangerous-git.sh".text = ''
          #!/bin/bash

          INPUT=$(cat)
          COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

          DANGEROUS_PATTERNS=(
            "git push"
            "git reset --hard"
            "git clean -fd"
            "git clean -f"
            "git branch -D"
            "git checkout \."
            "git restore \."
            "push --force"
            "reset --hard"
          )

          for pattern in "''${DANGEROUS_PATTERNS[@]}"; do
            if echo "$COMMAND" | grep -qE "$pattern"; then
              echo "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from doing this." >&2
              exit 2
            fi
          done

          exit 0
        '';
        ".claude/skills/git-guardrails/SKILL.md".text = ''
          ---
          name: git-guardrails-claude-code
          description: Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code.
          ---

          # Setup Git Guardrails

          Sets up a PreToolUse hook that intercepts and blocks dangerous git commands before Claude executes them.

          ## What Gets Blocked

          - `git push` (all variants including `--force`)
          - `git reset --hard`
          - `git clean -f` / `git clean -fd`
          - `git branch -D`
          - `git checkout .` / `git restore .`

          When blocked, Claude sees a message telling it that it does not have authority to access these commands.

          ## Steps

          ### 1. Ask scope

          Ask the user: install for **this project only** (`.claude/settings.json`) or **all projects** (`~/.claude/settings.json`)?

          ### 2. Copy the hook script

          The bundled script is at: [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

          Copy it to the target location based on scope:

          - **Project**: `.claude/hooks/block-dangerous-git.sh`
          - **Global**: `~/.claude/hooks/block-dangerous-git.sh`

          Make it executable with `chmod +x`.

          ### 3. Add hook to settings

          Add to the appropriate settings file:

          **Project** (`.claude/settings.json`):

          ```json
          {
            "hooks": {
              "PreToolUse": [
                {
                  "matcher": "Bash",
                  "hooks": [
                    {
                      "type": "command",
                      "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
                    }
                  ]
                }
              ]
            }
          }
          ```

          **Global** (`~/.claude/settings.json`):

          ```json
          {
            "hooks": {
              "PreToolUse": [
                {
                  "matcher": "Bash",
                  "hooks": [
                    {
                      "type": "command",
                      "command": "~/.claude/hooks/block-dangerous-git.sh"
                    }
                  ]
                }
              ]
            }
          }
          ```

          If the settings file already exists, merge the hook into existing `hooks.PreToolUse` array — don't overwrite other settings.

          ### 4. Ask about customization

          Ask if user wants to add or remove any patterns from the blocked list. Edit the copied script accordingly.

          ### 5. Verify

          Run a quick test:

          ```bash
          echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
          ```

          Should exit with code 2 and print a BLOCKED message to stderr.

        '';
        ".claude/skills/improve-codebase/SKILL.md".text = ''
          ---
          name: improve-codebase-architecture
          description: Explore a codebase to find opportunities for architectural improvement, focusing on making the codebase more testable by deepening shallow modules. Use when user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more AI-navigable.
          ---

          # Improve Codebase Architecture

          Explore a codebase like an AI would, surface architectural friction, discover opportunities for improving testability, and propose module-deepening refactors as GitHub issue RFCs.

          A **deep module** (John Ousterhout, "A Philosophy of Software Design") has a small interface hiding a large implementation. Deep modules are more testable, more AI-navigable, and let you test at the boundary instead of inside.

          ## Process

          ### 1. Explore the codebase

          Use the Agent tool with subagent_type=Explore to navigate the codebase naturally. Do NOT follow rigid heuristics — explore organically and note where you experience friction:

          - Where does understanding one concept require bouncing between many small files?
          - Where are modules so shallow that the interface is nearly as complex as the implementation?
          - Where have pure functions been extracted just for testability, but the real bugs hide in how they're called?
          - Where do tightly-coupled modules create integration risk in the seams between them?
          - Which parts of the codebase are untested, or hard to test?

          The friction you encounter IS the signal.

          ### 2. Present candidates

          Present a numbered list of deepening opportunities. For each candidate, show:

          - **Cluster**: Which modules/concepts are involved
          - **Why they're coupled**: Shared types, call patterns, co-ownership of a concept
          - **Dependency category**: See [REFERENCE.md](REFERENCE.md) for the four categories
          - **Test impact**: What existing tests would be replaced by boundary tests

          Do NOT propose interfaces yet. Ask the user: "Which of these would you like to explore?"

          ### 3. User picks a candidate

          ### 4. Frame the problem space

          Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

          - The constraints any new interface would need to satisfy
          - The dependencies it would need to rely on
          - A rough illustrative code sketch to make the constraints concrete — this is not a proposal, just a way to ground the constraints

          Show this to the user, then immediately proceed to Step 5. The user reads and thinks about the problem while the sub-agents work in parallel.

          ### 5. Design multiple interfaces

          Spawn 3+ sub-agents in parallel using the Agent tool. Each must produce a **radically different** interface for the deepened module.

          Prompt each sub-agent with a separate technical brief (file paths, coupling details, dependency category, what's being hidden). This brief is independent of the user-facing explanation in Step 4. Give each agent a different design constraint:

          - Agent 1: "Minimize the interface — aim for 1-3 entry points max"
          - Agent 2: "Maximize flexibility — support many use cases and extension"
          - Agent 3: "Optimize for the most common caller — make the default case trivial"
          - Agent 4 (if applicable): "Design around the ports & adapters pattern for cross-boundary dependencies"

          Each sub-agent outputs:

          1. Interface signature (types, methods, params)
          2. Usage example showing how callers use it
          3. What complexity it hides internally
          4. Dependency strategy (how deps are handled — see [REFERENCE.md](REFERENCE.md))
          5. Trade-offs

          Present designs sequentially, then compare them in prose.

          After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not just a menu.

          ### 6. User picks an interface (or accepts recommendation)

          ### 7. Create GitHub issue

          Create a refactor RFC as a GitHub issue using `gh issue create`. Use the template in [REFERENCE.md](REFERENCE.md). Do NOT ask the user to review before creating — just create it and share the URL.
        '';
        ".claude/skills/improve-codebase/REFERENCE.md".text = ''
          # Reference

            ## Dependency Categories

            When assessing a candidate for deepening, classify its dependencies:

            ### 1. In-process

            Pure computation, in-memory state, no I/O. Always deepenable — just merge the modules and test directly.

            ### 2. Local-substitutable

            Dependencies that have local test stand-ins (e.g., PGLite for Postgres, in-memory filesystem). Deepenable if the test substitute exists. The deepened module is tested with the local stand-in running in the test suite.

            ### 3. Remote but owned (Ports & Adapters)

            Your own services across a network boundary (microservices, internal APIs). Define a port (interface) at the module boundary. The deep module owns the logic; the transport is injected. Tests use an in-memory adapter. Production uses the real HTTP/gRPC/queue adapter.

            Recommendation shape: "Define a shared interface (port), implement an HTTP adapter for production and an in-memory adapter for testing, so the logic can be tested as one deep module even though it's deployed across a network boundary."

            ### 4. True external (Mock)

            Third-party services (Stripe, Twilio, etc.) you don't control. Mock at the boundary. The deepened module takes the external dependency as an injected port, and tests provide a mock implementation.

            ## Testing Strategy

            The core principle: **replace, don't layer.**

            - Old unit tests on shallow modules are waste once boundary tests exist — delete them
            - Write new tests at the deepened module's interface boundary
            - Tests assert on observable outcomes through the public interface, not internal state
            - Tests should survive internal refactors — they describe behavior, not implementation

            ## Issue Template

            <issue-template>

            ## Problem

            Describe the architectural friction:

            - Which modules are shallow and tightly coupled
            - What integration risk exists in the seams between them
            - Why this makes the codebase harder to navigate and maintain

            ## Proposed Interface

            The chosen interface design:

            - Interface signature (types, methods, params)
            - Usage example showing how callers use it
            - What complexity it hides internally

            ## Dependency Strategy

            Which category applies and how dependencies are handled:

            - **In-process**: merged directly
            - **Local-substitutable**: tested with [specific stand-in]
            - **Ports & adapters**: port definition, production adapter, test adapter
            - **Mock**: mock boundary for external services

            ## Testing Strategy

            - **New boundary tests to write**: describe the behaviors to verify at the interface
            - **Old tests to delete**: list the shallow module tests that become redundant
            - **Test environment needs**: any local stand-ins or adapters required

            ## Implementation Recommendations

            Durable architectural guidance that is NOT coupled to current file paths:

            - What the module should own (responsibilities)
            - What it should hide (implementation details)
            - What it should expose (the interface contract)
            - How callers should migrate to the new interface

            </issue-template>
        '';
        ".claude/skills/request-refactor/SKILL.md".text = ''
          ---
          name: request-refactor-plan
          description: Create a detailed refactor plan with tiny commits via user interview, then file it as a GitHub issue. Use when user wants to plan a refactor, create a refactoring RFC, or break a refactor into safe incremental steps.
          ---

          This skill will be invoked when the user wants to create a refactor request. You should go through the steps below. You may skip steps if you don't consider them necessary.

          1. Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

          2. Explore the repo to verify their assertions and understand the current state of the codebase.

          3. Ask whether they have considered other options, and present other options to them.

          4. Interview the user about the implementation. Be extremely detailed and thorough.

          5. Hammer out the exact scope of the implementation. Work out what you plan to change and what you plan not to change.

          6. Look in the codebase to check for test coverage of this area of the codebase. If there is insufficient test coverage, ask the user what their plans for testing are.

          7. Break the implementation into a plan of tiny commits. Remember Martin Fowler's advice to "make each refactoring step as small as possible, so that you can always see the program working."

          8. Create a GitHub issue with the refactor plan. Use the following template for the issue description:

          <refactor-plan-template>

          ## Problem Statement

          The problem that the developer is facing, from the developer's perspective.

          ## Solution

          The solution to the problem, from the developer's perspective.

          ## Commits

          A LONG, detailed implementation plan. Write the plan in plain English, breaking down the implementation into the tiniest commits possible. Each commit should leave the codebase in a working state.

          ## Decision Document

          A list of implementation decisions that were made. This can include:

          - The modules that will be built/modified
          - The interfaces of those modules that will be modified
          - Technical clarifications from the developer
          - Architectural decisions
          - Schema changes
          - API contracts
          - Specific interactions

          Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

          ## Testing Decisions

          A list of testing decisions that were made. Include:

          - A description of what makes a good test (only test external behavior, not implementation details)
          - Which modules will be tested
          - Prior art for the tests (i.e. similar types of tests in the codebase)

          ## Out of Scope

          A description of the things that are out of scope for this refactor.

          ## Further Notes (optional)

          Any further notes about the refactor.

          </refactor-plan-template>
        '';
        ".claude/skills/tdd/SKILL.md".text = ''
          ---
          name: tdd
          description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
          ---

          # Test-Driven Development

          ## Philosophy

          **Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

          **Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

          **Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

          See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

          ## Anti-Pattern: Horizontal Slices

          **DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

          This produces **crap tests**:

          - Tests written in bulk test _imagined_ behavior, not _actual_ behavior
          - You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
          - Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
          - You outrun your headlights, committing to test structure before understanding the implementation

          **Correct approach**: Vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

          ```
          WRONG (horizontal):
            RED:   test1, test2, test3, test4, test5
            GREEN: impl1, impl2, impl3, impl4, impl5

          RIGHT (vertical):
            RED→GREEN: test1→impl1
            RED→GREEN: test2→impl2
            RED→GREEN: test3→impl3
            ...
          ```

          ## Workflow

          ### 1. Planning

          Before writing any code:

          - [ ] Confirm with user what interface changes are needed
          - [ ] Confirm with user which behaviors to test (prioritize)
          - [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
          - [ ] Design interfaces for [testability](interface-design.md)
          - [ ] List the behaviors to test (not implementation steps)
          - [ ] Get user approval on the plan

          Ask: "What should the public interface look like? Which behaviors are most important to test?"

          **You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

          ### 2. Tracer Bullet

          Write ONE test that confirms ONE thing about the system:

          ```
          RED:   Write test for first behavior → test fails
          GREEN: Write minimal code to pass → test passes
          ```

          This is your tracer bullet - proves the path works end-to-end.

          ### 3. Incremental Loop

          For each remaining behavior:

          ```
          RED:   Write next test → fails
          GREEN: Minimal code to pass → passes
          ```

          Rules:

          - One test at a time
          - Only enough code to pass current test
          - Don't anticipate future tests
          - Keep tests focused on observable behavior

          ### 4. Refactor

          After all tests pass, look for [refactor candidates](refactoring.md):

          - [ ] Extract duplication
          - [ ] Deepen modules (move complexity behind simple interfaces)
          - [ ] Apply SOLID principles where natural
          - [ ] Consider what new code reveals about existing code
          - [ ] Run tests after each refactor step

          **Never refactor while RED.** Get to GREEN first.

          ## Checklist Per Cycle

          ```
          [ ] Test describes behavior, not implementation
          [ ] Test uses public interface only
          [ ] Test would survive internal refactor
          [ ] Code is minimal for this test
          [ ] No speculative features added
          ```

        '';
        ".claude/skills/tdd/deep-modules.md".text = ''
          # Deep Modules

          From "A Philosophy of Software Design":

          **Deep module** = small interface + lots of implementation

          ```
          ┌─────────────────────┐
          │   Small Interface   │  ← Few methods, simple params
          ├─────────────────────┤
          │                     │
          │                     │
          │  Deep Implementation│  ← Complex logic hidden
          │                     │
          │                     │
          └─────────────────────┘
          ```

          **Shallow module** = large interface + little implementation (avoid)

          ```
          ┌─────────────────────────────────┐
          │       Large Interface           │  ← Many methods, complex params
          ├─────────────────────────────────┤
          │  Thin Implementation            │  ← Just passes through
          └─────────────────────────────────┘
          ```

          When designing interfaces, ask:

          - Can I reduce the number of methods?
          - Can I simplify the parameters?
          - Can I hide more complexity inside?

        '';
        ".claude/skills/tdd/interface-design.md".text = ''
          # Interface Design for Testability

          Good interfaces make testing natural:

          1. **Accept dependencies, don't create them**

             ```typescript
             // Testable
             function processOrder(order, paymentGateway) {}

             // Hard to test
             function processOrder(order) {
               const gateway = new StripeGateway();
             }
             ```

          2. **Return results, don't produce side effects**

             ```typescript
             // Testable
             function calculateDiscount(cart): Discount {}

             // Hard to test
             function applyDiscount(cart): void {
               cart.total -= discount;
             }
             ```

          3. **Small surface area**
             - Fewer methods = fewer tests needed
             - Fewer params = simpler test setup

        '';
        ".claude/skills/tdd/mocking.md".text = ''
          # When to Mock

          Mock at **system boundaries** only:

          - External APIs (payment, email, etc.)
          - Databases (sometimes - prefer test DB)
          - Time/randomness
          - File system (sometimes)

          Don't mock:

          - Your own classes/modules
          - Internal collaborators
          - Anything you control

          ## Designing for Mockability

          At system boundaries, design interfaces that are easy to mock:

          **1. Use dependency injection**

          Pass external dependencies in rather than creating them internally:

          ```typescript
          // Easy to mock
          function processPayment(order, paymentClient) {
            return paymentClient.charge(order.total);
          }

          // Hard to mock
          function processPayment(order) {
            const client = new StripeClient(process.env.STRIPE_KEY);
            return client.charge(order.total);
          }
          ```

          **2. Prefer SDK-style interfaces over generic fetchers**

          Create specific functions for each external operation instead of one generic function with conditional logic:

          ```typescript
          // GOOD: Each function is independently mockable
          const api = {
            getUser: (id) => fetch(`/users/''${id}`),
            getOrders: (userId) => fetch(`/users/''${userId}/orders`),
            createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
          };

          // BAD: Mocking requires conditional logic inside the mock
          const api = {
            fetch: (endpoint, options) => fetch(endpoint, options),
          };
          ```

          The SDK approach means:
          - Each mock returns one specific shape
          - No conditional logic in test setup
          - Easier to see which endpoints a test exercises
          - Type safety per endpoint

        '';
        ".claude/skills/tdd/refactoring.md".text = ''
          # Refactor Candidates

          After TDD cycle, look for:

          - **Duplication** → Extract function/class
          - **Long methods** → Break into private helpers (keep tests on public interface)
          - **Shallow modules** → Combine or deepen
          - **Feature envy** → Move logic to where data lives
          - **Primitive obsession** → Introduce value objects
          - **Existing code** the new code reveals as problematic

        '';
        ".claude/skills/tdd/tests.md".text = ''
          # Good and Bad Tests

          ## Good Tests

          **Integration-style**: Test through real interfaces, not mocks of internal parts.

          ```typescript
          // GOOD: Tests observable behavior
          test("user can checkout with valid cart", async () => {
            const cart = createCart();
            cart.add(product);
            const result = await checkout(cart, paymentMethod);
            expect(result.status).toBe("confirmed");
          });
          ```

          Characteristics:

          - Tests behavior users/callers care about
          - Uses public API only
          - Survives internal refactors
          - Describes WHAT, not HOW
          - One logical assertion per test

          ## Bad Tests

          **Implementation-detail tests**: Coupled to internal structure.

          ```typescript
          // BAD: Tests implementation details
          test("checkout calls paymentService.process", async () => {
            const mockPayment = jest.mock(paymentService);
            await checkout(cart, payment);
            expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
          });
          ```

          Red flags:

          - Mocking internal collaborators
          - Testing private methods
          - Asserting on call counts/order
          - Test breaks when refactoring without behavior change
          - Test name describes HOW not WHAT
          - Verifying through external means instead of interface

          ```typescript
          // BAD: Bypasses interface to verify
          test("createUser saves to database", async () => {
            await createUser({ name: "Alice" });
            const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
            expect(row).toBeDefined();
          });

          // GOOD: Verifies through interface
          test("createUser makes user retrievable", async () => {
            const user = await createUser({ name: "Alice" });
            const retrieved = await getUser(user.id);
            expect(retrieved.name).toBe("Alice");
          });
          ```

        '';
        ".claude/skills/orient/SKILL.md".text = ''
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
        '';
        ".claude/skills/log-decision/SKILL.md".text = ''
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
        '';
        ".claude/skills/log-idea/SKILL.md".text = ''
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
        '';
        ".claude/skills/migrate-planning/SKILL.md".text = ''
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
        '';
        ".claude/skills/wrap-up/SKILL.md".text = ''
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
        '';
      };
    };
  };
}

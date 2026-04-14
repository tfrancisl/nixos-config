{
  config,
  lib,
  pkgs',
  ...
}: let
  cfg = config.acme.claude-code;
  inherit (config.acme.core) username;
in {
  options.acme = {
    claude-code.enable = lib.mkEnableOption "Claude Code";
  };

  config = lib.mkIf cfg.enable {
    hjem.users.${username} = {
      packages = [
        pkgs'.claude-code # Uses overlay from sadjow/claude-code-nix instead of nixpkgs
      ];
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
        ".claude/settings.json".source = ./claude/settings.json;
        ".claude/skills/improve-codebase/SKILL.md".source = ./claude/skills/improve-codebase/SKILL.md;
        ".claude/skills/improve-codebase/REFERENCE.md".source = ./claude/skills/improve-codebase/REFERENCE.md;
        ".claude/skills/request-refactor/SKILL.md".source = ./claude/skills/request-refactor/SKILL.md;
        ".claude/skills/tdd/SKILL.md".source = ./claude/skills/tdd/SKILL.md;
        ".claude/skills/tdd/deep-modules.md".source = ./claude/skills/tdd/deep-modules.md;
        ".claude/skills/tdd/interface-design.md".source = ./claude/skills/tdd/interface-design.md;
        ".claude/skills/tdd/mocking.md".source = ./claude/skills/tdd/mocking.md;
        ".claude/skills/tdd/refactoring.md".source = ./claude/skills/tdd/refactoring.md;
        ".claude/skills/tdd/tests.md".source = ./claude/skills/tdd/tests.md;
        ".claude/skills/orient/SKILL.md".source = ./claude/skills/orient/SKILL.md;
        ".claude/skills/log-decision/SKILL.md".source = ./claude/skills/log-decision/SKILL.md;
        ".claude/skills/log-idea/SKILL.md".source = ./claude/skills/log-idea/SKILL.md;
        ".claude/skills/migrate-planning/SKILL.md".source = ./claude/skills/migrate-planning/SKILL.md;
        ".claude/skills/wrap-up/SKILL.md".source = ./claude/skills/wrap-up/SKILL.md;
      };
    };
  };
}

{
  config,
  lib,
  pkgs',
  ...
}:
let
  cfg = config.acme.claude-code;
  inherit (config.acme.core) username;
in
{
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
        '';
        ".claude/settings.json" = {
          generator = lib.generators.toJSON { };
          value = {
            permissions = {
              allow = [
                "WebFetch(domain:docs.astral.sh)"
                "WebFetch(domain:docs.databricks.com)"
                "Bash(date:*)"
                "Bash(echo:*)"
                "Bash(cat:*)"
                "Bash(ls:*)"
                "Bash(mkdir:*)"
                "Bash(wc:*)"
                "Bash(head:*)"
                "Bash(tail:*)"
                "Bash(sort:*)"
                "Bash(grep:*)"
                "Bash(tr:*)"
                "Bash(git add:*)"
                "Bash(git commit:*)"
                "Bash(git status:*)"
                "Bash(git log:*)"
                "Bash(git diff:*)"
                "Bash(git tag:*)"
              ];
              defaultMode = "plan";
            };
            hooks = { };
            enabledPlugins = {
              "superpowers@claude-plugins-official" = true;
              "marimo-pair@marimo-pair" = true;
            };
            extraKnownMarketplaces = {
              marimo = {
                source = {
                  source = "github";
                  repo = "marimo-team/marimo-pair";
                };
              };
            };
            effortLevel = "medium";
            autoUpdatesChannel = "latest";
          };
        };
      };
    };
  };
}

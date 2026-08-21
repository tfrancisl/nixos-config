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
        ".claude/CLAUDE.md".source = ./CLAUDE.md;
        ".claude/settings.json".source = ./settings.json;
      };
    };
  };
}

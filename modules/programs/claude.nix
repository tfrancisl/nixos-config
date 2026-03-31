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
      files = {};
    };
  };
}

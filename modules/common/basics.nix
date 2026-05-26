{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
    environment.defaultPackages = lib.mkForce [ ];
    environment.shellAliases = lib.mkForce { };
    hjem.users.${username} = {
      packages = [
        pkgs.bat
        pkgs.dust
        pkgs.eza
        pkgs.htop
        pkgs.jq
        pkgs.ripgrep
        pkgs.hydra-check
        pkgs.alejandra
        pkgs.nixd
        pkgs.fzf
        pkgs.logseq
        pkgs.fd
      ];
    };
  };
}

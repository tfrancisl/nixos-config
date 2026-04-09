{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
  myNixFmt = pkgs.callPackage "${self}/packages/fmt.nix" {};
  mySyscheck = (pkgs.callPackage "${self}/packages/syscheck.nix" {}).package;
in {
  config = {
    environment.defaultPackages = lib.mkDefault [];
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
        myNixFmt
        mySyscheck
      ];
    };
  };
}

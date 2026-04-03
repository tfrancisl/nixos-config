{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
  myNixFmt = pkgs.callPackage "${self}/packages/fmt.nix" {};
in {
  config = {
    environment.defaultPackages = lib.mkDefault [];
    hjem.users.${username} = {
      packages = [
        pkgs.dust
        pkgs.htop
        pkgs.hydra-check
        pkgs.alejandra
        pkgs.nixd
        myNixFmt
      ];
    };
  };
}

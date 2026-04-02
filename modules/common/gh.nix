{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    gh = {
      package = lib.mkOption {
        description = "Zed editor package.";
        default = pkgs.gh;
        type = lib.types.package;
      };
    };
  };

  config = {
    hjem.users.${username} = {
      packages = [
        pkgs.gh
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    core.username = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = {
    hjem = {
      linker = pkgs.smfh;
      clobberByDefault = true;

      users.${username}.enable = true;
    };
  };
}

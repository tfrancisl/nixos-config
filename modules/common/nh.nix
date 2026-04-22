{ lib, ... }:
{
  options.acme.nh = {
    cleanArgs = lib.mkOption {
      type = lib.types.str;
      default = "--keep-since 10d --keep 4 --optimise";
      description = "Arguments passed to nh clean on both NixOS and Darwin";
    };
  };
}

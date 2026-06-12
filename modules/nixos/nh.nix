{ config, ... }:
let
  inherit (config.acme.core) username;
  inherit (config.acme.nh) cleanArgs;
in
{
  config = {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = cleanArgs;
    };
    environment.variables = {
      NH_FILE = "/home/${username}/nixos-config";
      NH_ATTRP = "nixosConfigurations.valhalla";
    };
  };
}

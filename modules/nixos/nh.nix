{config, ...}: let
  inherit (config.acme.core) username;
in {
  config = {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 10d --keep 4 --optimise";
      flake = "/home/${username}/nixos-config";
    };
  };
}

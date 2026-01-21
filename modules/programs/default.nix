{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  # move these elsewhere
  config = {
    environment.defaultPackages = lib.mkDefault [];
    hjem.users.${username} = {
      packages = with pkgs; [
        dust

        alacritty
        nnn
        htop

        hydra-check

        alejandra
        nixd

        rivalcfg # CLI for SteelSeries mouse hardware config
        lxqt.qps # qt process monitor

        swayimg
        shotman
      ];
    };
  };
  imports = [
    ./gaming
    ./hyprland
    ./zed
    ./firefox.nix
    ./git.nix
    ./greeting.nix
    ./pipewire.nix
    ./quickshell.nix
    ./sudo.nix
  ];
}

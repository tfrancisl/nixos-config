{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  config = {
    environment.defaultPackages = lib.mkDefault [];
    # move these elsewhere
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
    ./direnv.nix
  ];
}

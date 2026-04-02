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
        htop

        hydra-check

        alejandra
        nixd

        rivalcfg # CLI for SteelSeries mouse hardware config
      ];
    };
  };
  imports = [
    ./gaming
    ./hyprland
    ./zed
    ./firefox.nix
    ./git.nix
    ./greeter.nix
    ./pipewire.nix
    ./sudo.nix
    ./direnv.nix
    ./claude.nix
    ./nh.nix
  ];
}

{
  config,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
in {
  # move these elsewhere
  config = {
    hjem.users.${username} = {
      packages = with pkgs; [
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
  ];
}

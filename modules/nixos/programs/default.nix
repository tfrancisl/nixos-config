{
  config,
  pkgs,
  lib,
}: let
  inherit (config.acme.core) username;
in {
  config = {
    environment.defaultPackages = lib.mkDefault [];
    hjem.users.${username} = {
      packages = [
        pkgs.alacritty
      ];
    };
  };
  imports = [
    ./gaming
    ./hyprland
    ./firefox.nix
    ./greeter.nix
    ./pipewire.nix
    ./sudo.nix
    ./direnv.nix
    ./nh.nix
  ];
}

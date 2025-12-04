{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./settings.nix
    ./hardware
    (import ./system {
      inherit pkgs;
      username = "freya";
    })
    ./hyprland
    (import ./gaming {
      inherit pkgs lib config;
      username = "freya";
    })
  ];
}

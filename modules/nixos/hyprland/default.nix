{
  config,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.acme.hyprland;
in {
  options.acme = {
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };
  config = {
    programs.hyprland = {
      enable = lib.mkForce cfg.enable;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
  };

  imports = [
    ./settings.nix
  ];
}

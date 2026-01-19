{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options.acme = {
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };
  config = {
    programs.hyprland = {
      enable = lib.mkForce config.acme.hyprland.enable;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
  };

  imports = [
    ./settings.nix
  ];
}

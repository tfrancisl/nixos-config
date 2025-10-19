{ inputs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
  ]; # Hyprland maintained nixos mod
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    settings = { };
  };
}

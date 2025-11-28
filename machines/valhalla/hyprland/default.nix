{inputs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  imports = [
    inputs.hyprland.nixosModules.default # Hyprland maintained nixos mod
    ./settings.nix
    ./theme.nix
    ./binds.nix
    ./rules.nix
  ];
}

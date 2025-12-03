{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    quickshell
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  imports = [
    ./settings.nix
    ./theme.nix
    ./binds.nix
    ./rules.nix
    # Hyprland maintained nixos mod
    # https://github.com/hyprwm/Hyprland/blob/main/flake.nix
    # https://github.com/hyprwm/Hyprland/blob/main/nix/module.nix
    inputs.hyprland.nixosModules.default
  ];
}

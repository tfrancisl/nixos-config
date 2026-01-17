{
  config,
  lib,
  inputs,
  ...
}: {
  options.acme = {
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };
  config = {
    programs.hyprland = {
      enable = lib.mkForce config.acme.hyprland.enable;
    };
  };

  imports = [
    # Hyprland maintained nixos mod
    # https://github.com/hyprwm/Hyprland/blob/main/flake.nix
    # https://github.com/hyprwm/Hyprland/blob/main/nix/module.nix
    inputs.hyprland.nixosModules.default
    ./settings.nix
    ./theme.nix
    ./binds.nix
    ./rules.nix
  ];
}

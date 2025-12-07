{inputs, ...}: {
  programs.hyprland = {
    enable = true;
  };
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

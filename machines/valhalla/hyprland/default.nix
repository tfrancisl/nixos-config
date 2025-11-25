{inputs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  imports = [
    inputs.hyprland.nixosModules.default # Hyprland maintained nixos mod
    ./settings.nix
    ./theme.nix
    ./binds.nix
    ./rules.nix
  ];
}

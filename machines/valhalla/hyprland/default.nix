{inputs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  imports = [
    inputs.hyprland.nixosModules.default # Hyprland maintained nixos mod

    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./theme.nix
  ];
}

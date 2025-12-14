{inputs, ...}: {
  programs.hyprland = {
    enable = true;
  };

  nix.settings = {
    # get hyprland from cachix
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-substituters = ["https://hyprland.cachix.org"];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  imports = [
    ./uwsm.nix
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

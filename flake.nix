{
  description = "NixOS flake";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = ["https://hyprland.cachix.org"];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs = inputs @ {self, ...}: let
    specialArgs = {inherit self inputs;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        {
          flake.nixosConfigurations.valhalla = inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ./users/freya # Portable user configuration
              ./machines/valhalla/settings.nix
              ./machines/valhalla/hardware
              ./machines/valhalla/home
              ./machines/valhalla/hyprland
              ./machines/valhalla/system
            ];
            inherit specialArgs;
          };
        }
      ];
    };
}

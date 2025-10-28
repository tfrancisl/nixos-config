{
  description = "NixOS flake";

  nixConfig = {
    # get hyprland from cachix
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
              ./valhalla/settings.nix
              ./valhalla/hardware
              ./valhalla/home
              ./valhalla/hyprland
              ./valhalla/system
            ];
            inherit specialArgs;
          };
        }
      ];
    };
}

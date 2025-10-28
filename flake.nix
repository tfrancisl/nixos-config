{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    specialArgs = {inherit self inputs;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        {
          flake.nixosConfigurations.valhalla = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = [
              ./valhalla/settings.nix
              ./valhalla/hardware
              ./valhalla/home
              ./valhalla/hyprland
              ./valhalla/system
            ];
          };
        }
      ];
    };
}

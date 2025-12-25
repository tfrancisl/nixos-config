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
    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs = inputs @ {self, ...}: let
    specialArgs = {inherit self inputs;};
  in {
    nixosConfigurations = {
      valhalla = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          {
            config = {
              system_user.username = "freya";
              greeting.mode = "instalogin";
            };
          }
          ./machines/valhalla
        ];
      };
    };
  };
}

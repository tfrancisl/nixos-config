{ self, inputs, ... }:
{

  flake.nixosConfigurations =
    let
      specialArgs = { inherit inputs self; };
    in
    {
      valhalla = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hardware
          ./home
          ./hyprland
          ./system
          ./settings.nix
        ];
      };
    };
}

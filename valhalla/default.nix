{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      specialArgs = { inherit inputs self; };
    in
    {
      valhalla = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./settings.nix
          ./hardware
          ./home
          ./hyprland
          ./system
        ];
      };
    };
}

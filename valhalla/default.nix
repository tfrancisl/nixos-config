{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      specialArgs = { inherit inputs self; };
    in
    {
      valhalla = nixosSystem {
        inherit specialArgs;
        modules = [
          ./configuration.nix
          ./nvidia.nix
          ./hardware-configuration.nix
        ];
      };
    };
}

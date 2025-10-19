{ self, inputs, ... }:
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
          ./system.nix
          ./hardware-configuration.nix
          ./nvidia.nix
          ./programs.nix
          ./users.nix
        ];
      };
    };
}

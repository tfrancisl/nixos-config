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
          ./hyprland
          ./hardware
          ./programs.nix
          ./services.nix
          ./system.nix
          ./users.nix
        ];
      };
    };
}

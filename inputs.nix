let
  inputs = import ./.tack;
  inherit (inputs)
    nixpkgs
    hjem
    claude
    ncro
    nix-darwin
    ;
  mkNixosSystem =
    {
      system,
      modules,
      packages,
    }:
    nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit nixpkgs;
        pkgs' = packages.${system};
      };
    };
  mkDarwinSystem =
    {
      system,
      modules,
      packages,
    }:
    nix-darwin.lib.darwinSystem {
      inherit system modules;
      specialArgs = {
        inherit nixpkgs;
        pkgs' = packages.${system};
      };
    };
in
{
  inherit
    nixpkgs
    hjem
    claude
    ncro
    mkNixosSystem
    mkDarwinSystem
    ;
}

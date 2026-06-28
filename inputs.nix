let

  sources = import ./npins;
  lib = import "${sources.nixpkgs}/lib";
  lib' = import ./lib { inherit lib; };

  relevantSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forRelevantSystems = lib.genAttrs relevantSystems;

  pkgs = forRelevantSystems (
    system:
    import sources.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );

  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
  darwinSystem = import "${sources.nix-darwin}/eval-config.nix";

  hjemNixosModule = (import "${sources.hjem}/modules/nixos").default;
  hjemDarwinModule = (import "${sources.hjem}/modules/nix-darwin").default;

in
{
  inherit
    sources
    lib
    lib'
    relevantSystems
    forRelevantSystems
    pkgs
    nixosSystem
    darwinSystem
    hjemNixosModule
    hjemDarwinModule
    ;

}

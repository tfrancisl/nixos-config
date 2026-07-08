let

  inputs = import ./.tack;

  lib = inputs.nixpkgs.lib;

  relevantSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forRelevantSystems = lib.genAttrs relevantSystems;

  pkgs = forRelevantSystems (system: inputs.nixpkgs.legacyPackages.${system});

  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
  darwinSystem = inputs.nix-darwin.lib.darwinSystem;

  hjemNixosModule = inputs.hjem.nixosModules.default;
  hjemDarwinModule = inputs.hjem.darwinModules.default;

in
{
  inherit
    inputs
    lib
    relevantSystems
    forRelevantSystems
    pkgs
    nixosSystem
    darwinSystem
    hjemNixosModule
    hjemDarwinModule
    ;

}

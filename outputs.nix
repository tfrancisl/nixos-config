{
  inputs,
  nixosSystem,
  darwinSystem,
  forRelevantSystems,
  pkgs,
  lib,
  hjemNixosModule,
  hjemDarwinModule,
  ...
}:
let
  listNixFilesRecursive =
    module: lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive module);

  nixpkgs-source = inputs.nixpkgs;
  mkNixosSystem =
    {
      system,
      modules,
    }:
    nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit nixpkgs-source;
        pkgs' = packages.${system};
      };
    };

  mkDarwinSystem =
    {
      system,
      modules,
    }:
    darwinSystem {
      inherit lib;
      specialArgs = {
        inherit nixpkgs-source;
        pkgs' = packages.${system};
      };
      modules = modules ++ [
        (
          { lib, ... }:
          {
            nixpkgs = {
              system = lib.mkDefault system;
              source = lib.mkDefault inputs.nixpkgs;
              flake.source = lib.mkDefault inputs.nixpkgs.outPath;
            };
            system.checks.verifyNixPath = lib.mkDefault false;
          }
        )
      ];
    };

  packages = forRelevantSystems (
    system:
    let
      pkgs' = pkgs.${system};
      fzfDiffTools = pkgs'.callPackage ./packages/fzf-diff-tools.nix { };
    in
    {
      fzfGitLog = fzfDiffTools.gl;
      fzfGitDiff = fzfDiffTools.gd;
      waylandScreenshot = pkgs'.callPackage ./packages/screenshot.nix { };
      claude-code = inputs.claude.outputs.packages.${system}.default;
      ncroPkg = inputs.ncro.packages.${system}.ncro;
    }
  );

  commonModules = listNixFilesRecursive ./modules/common;

in
{

  inherit packages;

  nixosConfigurations.valhalla =
    let
      system = "x86_64-linux";
      ncroNixosModule = inputs.ncro.nixosModules.default;
    in
    mkNixosSystem {
      inherit system;
      modules = [
        hjemNixosModule
        ncroNixosModule
      ]
      ++ (listNixFilesRecursive ./machines/valhalla)
      ++ commonModules
      ++ (listNixFilesRecursive ./modules/nixos);
    };

  darwinConfigurations.mymac =
    let
      system = "aarch64-darwin";
    in
    mkDarwinSystem {
      inherit system;
      modules = [
        hjemDarwinModule
      ]
      ++ (listNixFilesRecursive ./machines/mymac)
      ++ commonModules
      ++ (listNixFilesRecursive ./modules/darwin);
    };

  formatter = forRelevantSystems (system: pkgs.${system}.nixfmt-tree);

}

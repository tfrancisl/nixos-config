{
  nixosSystem,
  darwinSystem,
  sources,
  forRelevantSystems,
  pkgs,
  lib,
  lib',
  hjemNixosModule,
  hjemDarwinModule,
  ...
}:
let
  inherit (lib') listNixFilesRecursive;
  nixpkgs-source = sources.nixpkgs;
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
              source = lib.mkDefault sources.nixpkgs;
              flake.source = lib.mkDefault sources.nixpkgs.outPath;
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
      exiled-exchange-2 = pkgs'.callPackage ./packages/exiled-exchange-2.nix { };
      claude-code = pkgs'.callPackage "${sources.claude}/package.nix" { };
    }
  );

  commonModules = listNixFilesRecursive ./modules/common;
in
{

  inherit packages;

  nixosConfigurations.valhalla =
    let
      system = "x86_64-linux";
    in
    mkNixosSystem {
      inherit system;
      modules = [
        hjemNixosModule
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

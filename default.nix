let
  sources = import ./npins;
  lib = import "${sources.nixpkgs}/lib";
  lib' = import ./lib { inherit lib; };
  inherit (lib') listNixFilesRecursive;

  relevantSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forRelevantSystems = lib.genAttrs relevantSystems;

  pkgsFor =
    s:
    import sources.nixpkgs {
      system = s;
      config.allowUnfree = true;
    };

  hjemNixosModule = (import "${sources.hjem}/modules/nixos").default;
  hjemDarwinModule = (import "${sources.hjem}/modules/nix-darwin").default;

  nixosSystem =
    {
      system,
      modules,
      specialArgs ? { },
    }:
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
      inherit system specialArgs;
      modules = modules ++ [
        { nixpkgs.flake.source = sources.nixpkgs.outPath; }
      ];
    };

  # Mirrors `nix-darwin.lib.darwinSystem` minus the flake-self version metadata.
  darwinSystem =
    {
      system,
      modules,
      specialArgs ? { },
    }:
    import "${sources.nix-darwin}/eval-config.nix" {
      inherit lib specialArgs;
      modules = modules ++ [
        (
          { lib, ... }:
          {
            nixpkgs.system = lib.mkDefault system;
            nixpkgs.source = lib.mkDefault sources.nixpkgs;
            nixpkgs.flake.source = lib.mkDefault sources.nixpkgs.outPath;
            system.checks.verifyNixPath = lib.mkDefault false;
          }
        )
      ];
    };

  packages = forRelevantSystems (
    s:
    let
      p = pkgsFor s;
      fzfDiffTools = p.callPackage ./packages/fzf-diff-tools.nix { };
    in
    {
      fzfGitLog = fzfDiffTools.gl;
      fzfGitDiff = fzfDiffTools.gd;
      waylandScreenshot = p.callPackage ./packages/screenshot.nix { };
    }
  );

  pkgsFor' =
    s:
    packages.${s}
    // {
      claude-code = (pkgsFor s).callPackage "${sources.claude}/package.nix" { };
    };

  commonModules = listNixFilesRecursive ./modules/common;
in
{
  inherit packages;

  nixosConfigurations.valhalla = nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit lib';
      pkgs' = pkgsFor' "x86_64-linux";
    };
    modules = [
      hjemNixosModule
    ]
    ++ (listNixFilesRecursive ./machines/valhalla)
    ++ commonModules
    ++ (listNixFilesRecursive ./modules/nixos);
  };

  darwinConfigurations.mymac = darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit lib';
      pkgs' = pkgsFor' "aarch64-darwin";
    };
    modules = [
      hjemDarwinModule
    ]
    ++ (listNixFilesRecursive ./machines/mymac)
    ++ commonModules
    ++ (listNixFilesRecursive ./modules/darwin);
  };

  formatter = forRelevantSystems (s: (pkgsFor s).nixfmt-tree);

  checks = forRelevantSystems (
    s:
    import ./checks.nix {
      src = ./.;
      pkgs = pkgsFor s;
    }
  );
}

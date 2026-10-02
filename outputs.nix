{
  nixpkgs,
  hjem,
  hjem-impure,
  ncro,
  rom,
  ...
}:
let
  relevantSystems = [
    "x86_64-linux"
  ];

  forRelevantSystems = nixpkgs.lib.genAttrs relevantSystems;

  pkgs = forRelevantSystems (system: nixpkgs.legacyPackages.${system});

  packages = forRelevantSystems (
    system:
    let
      pkgs' = pkgs.${system};
      nixPackage = pkgs'.lixPackageSets.git.lix;
      romPkg = rom.packages.${system}.default;
    in
    {
      inherit nixPackage romPkg;
      # `nix` that renders build progress with ROM on a TTY
      nixRom = pkgs'.callPackage ./packages/nix-rom.nix {
        nix = nixPackage;
        rom = romPkg;
      };
      waylandScreenshot = pkgs'.callPackage ./packages/screenshot.nix { };
      ncroPkg = ncro.packages.${system}.ncro;
      hjemCli = hjem.packages.${system}.hjem;
      darwinDots = import ./export/darwin {
        inherit (nixpkgs) lib;
        inherit hjem;
        pkgs = pkgs';
      };
    }
  );

  pkgsPrimeModule =
    { config, ... }:
    {
      _module.args.pkgs' = packages.${config.nixpkgs.hostPlatform.system};
    };

  listNixFilesRecursive =
    let
      inherit (nixpkgs) lib;
    in
    module: lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive module);

  commonModules = listNixFilesRecursive ./modules/common;
  hjemImpureModule = hjem-impure.hjemModules.default;

in
{
  inherit packages;

  nixosConfigurations.valhalla = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit nixpkgs hjemImpureModule;
    };
    modules = [
      pkgsPrimeModule
      hjem.nixosModules.default
      ncro.nixosModules.default
    ]
    ++ (listNixFilesRecursive ./machines/valhalla)
    ++ commonModules
    ++ (listNixFilesRecursive ./modules/nixos);
  };
}

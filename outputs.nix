{
  nixpkgs,
  hjem,
  hjem-impure,
  ncro,
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
    in
    {
      waylandScreenshot = pkgs'.callPackage ./packages/screenshot.nix { };
      ncroPkg = ncro.packages.${system}.ncro;
      hjemCli = hjem.packages.${system}.hjem;
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

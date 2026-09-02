{
  nixpkgs,
  hjem,
  claude,
  ncro,
  nix-darwin,
  ...
}:
let
  relevantSystems = [
    "x86_64-linux"
    "aarch64-darwin"
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
      claude-code = claude.outputs.packages.${system}.default;
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

in
{
  inherit packages;

  nixosConfigurations.valhalla = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit nixpkgs;
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

  darwinConfigurations.mymac = nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit nixpkgs;
    };
    modules = [
      pkgsPrimeModule
      hjem.darwinModules.default
    ]
    ++ (listNixFilesRecursive ./machines/mymac)
    ++ commonModules
    ++ (listNixFilesRecursive ./modules/darwin);
  };
}

{
  nixpkgs,
  hjem,
  claude,
  ncro,
  mkNixosSystem,
  mkDarwinSystem,
  ...
}:
let
  relevantSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forRelevantSystems = nixpkgs.lib.genAttrs relevantSystems;
  pkgs = forRelevantSystems (system: nixpkgs.legacyPackages.${system});

  inherit (nixpkgs) lib;

  listNixFilesRecursive =
    module: lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive module);

  packages = forRelevantSystems (
    system:
    let
      pkgs' = pkgs.${system};
    in
    {
      waylandScreenshot = pkgs'.callPackage ./packages/screenshot.nix { };
      claude-code = claude.outputs.packages.${system}.default;
      ncroPkg = ncro.packages.${system}.ncro;
    }
  );

  commonModules = listNixFilesRecursive ./modules/common;
in
{
  inherit packages;

  nixosConfigurations.valhalla =
    let
      system = "x86_64-linux";
      ncroNixosModule = ncro.nixosModules.default;
      hjemNixosModule = hjem.nixosModules.default;
    in
    mkNixosSystem {
      inherit system packages;
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
      hjemDarwinModule = hjem.darwinModules.default;
    in
    mkDarwinSystem {
      inherit system packages;
      modules = [
        hjemDarwinModule
      ]
      ++ (listNixFilesRecursive ./machines/mymac)
      ++ commonModules
      ++ (listNixFilesRecursive ./modules/darwin);
    };
}

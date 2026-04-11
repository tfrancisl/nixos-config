{
  description = "TFL's nix flake for NixOS and MacOS.";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    claude = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (self.lib') listNixFilesRecursive;
  in {
    lib' = import ./lib {inherit (inputs.nixpkgs) lib;};

    nixosConfigurations = {
      valhalla = let
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self;
          inherit (self) lib';
          inherit (inputs.claude.packages.${system}) claude-code;
        };
        modules =
          [
            inputs.hjem.nixosModules.default
          ]
          ++ (listNixFilesRecursive
            ./machines/valhalla)
          ++ (listNixFilesRecursive
            ./modules/common)
          ++ (listNixFilesRecursive
            ./modules/nixos);
      in
        inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs system modules;
        };
    };
    darwinConfigurations = {
      mymac = let
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs self;
          inherit (inputs.claude.packages.${system}) claude-code;
        };
        modules =
          [
            inputs.hjem.darwinModules.default
          ]
          ++ (listNixFilesRecursive
            ./machines/mymac)
          ++ (listNixFilesRecursive
            ./modules/common)
          ++ (listNixFilesRecursive
            ./modules/darwin);
      in
        inputs.nix-darwin.lib.darwinSystem {
          inherit specialArgs system modules;
        };
    };

    # Cross-platform checks: shellcheck + lib unit tests. Run: nix flake check
    checks = let
      forSystem = system:
        import ./checks.nix {pkgs = inputs.nixpkgs.legacyPackages.${system};};
    in {
      x86_64-linux = forSystem "x86_64-linux";
      aarch64-darwin = forSystem "aarch64-darwin";
    };

    devShells.x86_64-linux.default = let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        packages = [];
        name = "nixos-config";
      };
  };
}

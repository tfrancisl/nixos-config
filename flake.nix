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

  outputs =
    inputs@{ self, ... }:
    let
      lib' = import ./lib { inherit (inputs.nixpkgs) lib; };
      inherit (lib') listNixFilesRecursive;
      relevantSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forRelevantSystems = inputs.nixpkgs.lib.genAttrs relevantSystems;
      commonModules = listNixFilesRecursive ./modules/common;
      pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
      pkgsFor' =
        system:
        self.packages.${system}
        // {
          inherit (inputs.claude.packages.${system}) claude-code;
        };
    in
    {
      nixosConfigurations = {
        valhalla =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit lib';
              pkgs' = pkgsFor' system;
            };
            modules = [
              inputs.hjem.nixosModules.default
            ]
            ++ (listNixFilesRecursive ./machines/valhalla)
            ++ commonModules
            ++ (listNixFilesRecursive ./modules/nixos);
          in
          inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs system modules;
          };
      };

      darwinConfigurations = {
        mymac =
          let
            system = "aarch64-darwin";
            specialArgs = {
              inherit lib';
              pkgs' = pkgsFor' system;
            };
            modules = [
              inputs.hjem.darwinModules.default
            ]
            ++ (listNixFilesRecursive ./machines/mymac)
            ++ commonModules
            ++ (listNixFilesRecursive ./modules/darwin);
          in
          inputs.nix-darwin.lib.darwinSystem {
            inherit specialArgs system modules;
          };
      };

      formatter = forRelevantSystems (system: (pkgsFor system).nixfmt-tree);

      checks = forRelevantSystems (
        system:
        import ./checks.nix {
          inherit self;
          pkgs = pkgsFor system;
        }
      );

      packages = forRelevantSystems (
        system:
        let
          pkgs = pkgsFor system;
          fzfDiffTools = pkgs.callPackage ./packages/fzf-diff-tools.nix { };
        in
        {
          fzfGitLog = fzfDiffTools.gl;
          fzfGitDiff = fzfDiffTools.gd;
          waylandScreenshot = pkgs.callPackage ./packages/screenshot.nix { };
        }
      );
    };
}

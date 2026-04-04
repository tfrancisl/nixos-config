{
  description = "NixOS flake";

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

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self.lib') listNixFilesRecursive;
  in {
    lib' = import ./lib {inherit (nixpkgs) lib;};

    nixosConfigurations = {
      valhalla = let
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs system self;
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
          inherit specialArgs system;
          inherit modules;
        };
    };
    darwinConfigurations = {
      mymac = let
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs system self;
          inherit (inputs.claude.packages.${system}) claude-code;
        };
        modules =
          [
            {
              system.configurationRevision = self.rev or self.dirtyRev or null;
              system.stateVersion = 6;
            }
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
          inherit specialArgs system;
          inherit modules;
        };
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

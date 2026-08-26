let
  inputs = import ./inputs.nix;
  system = builtins.currentSystem;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
pkgs.mkShell {
  name = "nixos-config";
  TACK_DIR = "./.tack"; # my inputs.nix confuses tack
  packages = [
    pkgs.just
    pkgs.tack
    pkgs.treefmt
    pkgs.nixfmt
    pkgs.taplo
    (pkgs.callPackage ./packages/jqfmt.nix { })
    pkgs.deadnix
    pkgs.statix
    pkgs.nixf-diagnose
  ];
}

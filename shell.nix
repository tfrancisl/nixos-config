let
  inputs = import ./inputs.nix;
  system = builtins.currentSystem;
  pkgs = inputs.pkgs.${system};
in
pkgs.mkShell {
  name = "nixos-config";
  TACK_DIR=./.tack; # my inputs.nix confuses tack
  packages = [
    pkgs.just
    pkgs.tack
    pkgs.nixfmt-tree
    pkgs.deadnix
    pkgs.statix
    pkgs.nixf-diagnose
  ];
}

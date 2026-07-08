let
  inputs = import ./inputs.nix;
  system = builtins.currentSystem;
  pkgs = inputs.pkgs.${system};
in
pkgs.mkShell {
  name = "nixos-config";
  packages = [
    pkgs.just
    pkgs.npins
    pkgs.nixfmt-tree
    pkgs.deadnix
    pkgs.statix
    pkgs.nixf-diagnose
  ];
}

let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "nixos-config";
  packages = [
    pkgs.npins
    pkgs.nixfmt-tree
    pkgs.deadnix
    pkgs.statix
    pkgs.nixf-diagnose
  ];
}

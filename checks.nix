{
  self,
  pkgs,
}:
let
  syscheck = pkgs.callPackage ./packages/syscheck.nix { };
  hyprlib = import ./lib/hyprland.nix { inherit (pkgs) lib; };
  lintChecks = {
    check-deadnix = pkgs.runCommand "check-deadnix" { } ''
      ${pkgs.deadnix}/bin/deadnix --fail ${self}
      touch $out
    '';
    check-statix = pkgs.runCommand "check-statix" { } ''
      ${pkgs.statix}/bin/statix check ${self}
      touch $out
    '';
    check-nixf-diagnose = pkgs.runCommand "check-nixf-diagnose" { } ''
      ${pkgs.nixf-diagnose}/bin/nixf-diagnose ${self}/**.nix
      touch $out
    '';
  };
in
syscheck.checks
// lintChecks
// {
  test-flattenAttrs =
    let
      result = hyprlib.flattenAttrs (p: k: "${p}:${k}") {
        a = "3";
        b = {
          c = "4";
          d = "5";
        };
      };
      pass =
        result == {
          a = "3";
          "b:c" = "4";
          "b:d" = "5";
        };
    in
    assert pass;
    pkgs.runCommand "test-flattenAttrs" { } "touch $out";

  test-toHyprlang =
    let
      result = hyprlib.toHyprlang { } {
        "$mod" = "SUPER";
        general = {
          gaps_in = 4;
        };
      };
      pass =
        builtins.isString result
        && builtins.match ".*\\$mod = SUPER.*" result != null
        && builtins.match ".*general:gaps_in = 4.*" result != null;
    in
    assert pass;
    pkgs.runCommand "test-toHyprlang" { } "touch $out";
}

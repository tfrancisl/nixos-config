{pkgs}: let
  syscheck = pkgs.callPackage ./packages/syscheck.nix {};
  hyprlib = import ./lib/hyprland.nix {inherit (pkgs) lib;};
in
  syscheck.checks
  // {
    test-flattenAttrs = let
      result = hyprlib.flattenAttrs (p: k: "${p}:${k}") {
        a = "3";
        b = {
          c = "4";
          d = "5";
        };
      };
      pass =
        result
        == {
          a = "3";
          "b:c" = "4";
          "b:d" = "5";
        };
    in
      assert pass;
        pkgs.runCommand "test-flattenAttrs" {} "touch $out";

    test-toHyprlang = let
      result = hyprlib.toHyprlang {} {
        "$mod" = "SUPER";
        general = {gaps_in = 4;};
      };
      pass = builtins.isString result
        && builtins.match ".*\\$mod = SUPER.*" result != null
        && builtins.match ".*general:gaps_in = 4.*" result != null;
    in
      assert pass;
        pkgs.runCommand "test-toHyprlang" {} "touch $out";
  }

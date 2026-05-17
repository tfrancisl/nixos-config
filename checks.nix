{
  self,
  pkgs,
}:
let
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
lintChecks
// {

}

{
  src,
  pkgs,
}:
let
  lintChecks = {
    check-deadnix = pkgs.runCommand "check-deadnix" { } ''
      ${pkgs.deadnix}/bin/deadnix --fail ${src}
      touch $out
    '';
    check-statix = pkgs.runCommand "check-statix" { } ''
      ${pkgs.statix}/bin/statix check ${src}
      touch $out
    '';
    check-nixf-diagnose = pkgs.runCommand "check-nixf-diagnose" { } ''
      ${pkgs.nixf-diagnose}/bin/nixf-diagnose ${src}/**.nix
      touch $out
    '';
  };
in
lintChecks
// {

}

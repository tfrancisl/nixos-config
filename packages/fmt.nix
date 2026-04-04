{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nfmt";
  runtimeInputs = [
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix
    pkgs.fd
    pkgs.nixf-diagnose
  ];
  text = ''
    fd "$@" -t f -e nix -x statix fix -- '{}'
    fd "$@" -t f -e nix -X deadnix -e -- '{}' \; -X alejandra -q '{}'
    fd "$@" -t f -e nix -x nixf-diagnose --auto-fix -- '{}'
  '';
}

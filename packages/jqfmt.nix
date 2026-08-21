{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "jqfmt";
  runtimeInputs = [ pkgs.jq ];
  text = ''
    for f in "$@"; do
      tmp="$(mktemp)"
      jq . "$f" > "$tmp"
      mv "$tmp" "$f"
    done
  '';
}

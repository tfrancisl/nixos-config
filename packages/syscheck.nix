{pkgs, ...}: let
  inherit (pkgs.stdenv) isLinux;

  # Shared formatting helpers — prepended to both platform scripts
  formatHelpers = builtins.readFile ./syscheck/format-helpers.sh;

  linuxText = formatHelpers + "\n" + builtins.readFile ./syscheck/linux.sh;
  darwinText = formatHelpers + "\n" + builtins.readFile ./syscheck/darwin.sh;

  runtimeInputs =
    if isLinux
    then with pkgs; [lm_sensors pciutils gawk]
    else [pkgs.gawk];

  text =
    if isLinux
    then linuxText
    else darwinText;

  # Shellcheck a script without requiring its runtime deps.
  # Used by flake checks to validate the foreign platform's script.
  shellcheckDrv = name: scriptText:
    pkgs.runCommand "shellcheck-${name}" {nativeBuildInputs = [pkgs.shellcheck];} ''
      cat > script.sh <<'SCRIPT'
      #!/usr/bin/env bash
      set -o errexit
      set -o nounset
      set -o pipefail
      ${scriptText}
      SCRIPT
      shellcheck script.sh
      touch $out
    '';
in {
  # The syscheck binary for the current platform
  package = pkgs.writeShellApplication {
    name = "syscheck";
    inherit runtimeInputs text;
  };

  # Shellcheck checks for both platforms (used by flake checks)
  checks = {
    shellcheck-linux = shellcheckDrv "linux" linuxText;
    shellcheck-darwin = shellcheckDrv "darwin" darwinText;
  };
}

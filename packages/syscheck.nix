{pkgs, ...}: let
  isLinux = pkgs.stdenv.isLinux;

  # Shared formatting helpers — prepended to both platform scripts
  formatHelpers = builtins.readFile ./syscheck/format-helpers.sh;

  linuxBody = builtins.readFile ./syscheck/linux.sh;
  darwinBody = builtins.readFile ./syscheck/darwin.sh;

  runtimeInputs =
    if isLinux
    then with pkgs; [lm_sensors pciutils gawk]
    else [pkgs.gawk];

  text =
    if isLinux
    then formatHelpers + "\n" + linuxBody
    else formatHelpers + "\n" + darwinBody;
in
  pkgs.writeShellApplication {
    name = "syscheck";
    inherit runtimeInputs text;
  }

{...}: {
  # Portable user configuration for freya
  # Can be imported into NixOS configurations or adapted for nix-darwin
  #
  # Usage in machine config:
  #   imports = [ ../../users/freya ];
  #
  # Or with custom username:
  #   imports = [ (import ../../users/freya { username = "other-user"; }) ];

  imports = [
    ./packages.nix
    ./shell.nix
    ./programs.nix
  ];
}

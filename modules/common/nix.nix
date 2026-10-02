{
  lib,
  pkgs',
  nixpkgs,
  ...
}:
{
  nix = {
    package = pkgs'.nixPackage;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix-path = [ "nixpkgs=${nixpkgs}" ];
      warn-dirty = false;
      allow-import-from-derivation = false;
      accept-flake-config = true;
      use-xdg-base-directories = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
    };
  };

  # shadows nix's own bin/nix in the system profile
  environment.systemPackages = [ (lib.hiPrio pkgs'.nixRom) ];

  nixpkgs.config.allowUnfree = true;
}

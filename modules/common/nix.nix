{ pkgs, nixpkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix; # rather use git.latest but its broken
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

  nixpkgs.config.allowUnfree = true;
}

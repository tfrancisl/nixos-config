{ pkgs, nixpkgs-source, ... }:
{
  config = {
    nix = {
      package = pkgs.lixPackageSets.git.lix;
      nixPath = [ "nixpkgs=${nixpkgs-source}" ];
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        allow-import-from-derivation = false;
        accept-flake-config = true;
        use-xdg-base-directories = true;
        allowed-users = [ "@wheel" ];
        trusted-users = [ "@wheel" ];
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}

{pkgs, ...}: {
  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      allow-import-from-derivation = false;
      accept-flake-config = true;
      use-xdg-base-directories = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };
    nix.package = pkgs.lixPackageSets.git.lix;

    nixpkgs.config.allowUnfree = true;
  };
}

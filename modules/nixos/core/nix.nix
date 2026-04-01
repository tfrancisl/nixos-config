{config, ...}: let
  inherit (config.acme.core) username;
in {
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
      download-buffer-size = 500 * 1024 * 1024;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 10d --keep 4 --optimise";
      flake = "/home/${username}/nixos-config";
    };

    nixpkgs.config = {
      allowUnfree = true;
      documentation.nixos.enable = false;
    };
  };
}

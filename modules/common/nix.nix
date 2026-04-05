_: {
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
      download-buffer-size = 500 * 1024 * 1024; # 500 MiB — helps on fast connections
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };

    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
  };
}

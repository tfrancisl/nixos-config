{
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "America/New_York"; # EST/EDT
  i18n.defaultLocale = "en_US.UTF-8";

  # Track non-free software explicitly
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "discord"
      "steam"
      "steam-unwrapped"
      "spotify"
      "firefox-bin"
      "firefox-bin-unwrapped"
      "lunar-client"
      "lunarclient"
      "prismlauncher"
    ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "valhalla";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "25.05"; # Do not change this!

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    fallback = true;
    connect-timeout = 10;

    # get hyprland from cachix
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-substituters = ["https://hyprland.cachix.org"];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Can add more settings to nixConfig in flake
    trusted-users = ["freya"];
  };
}

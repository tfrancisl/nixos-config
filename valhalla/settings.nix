{pkgs, ...}: {
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
      "geekbench"
    ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}

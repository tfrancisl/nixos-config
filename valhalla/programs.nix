{ pkgs, ... }:
{

  # Track non-free software explicitly
  nixpkgs.config.allowUnfreePredicate =
    pkg:
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

  environment.systemPackages = with pkgs; [
    tuigreet

    qpwgraph
    pavucontrol
    usbutils
    gparted

    wlrctl
    xdg-utils
    hyprpolkitagent
    hyprcursor
    hyprpaper

    graphite-cursors

    geekbench

  ];

  programs = {
    fish.enable = true;
    firefox = {
      enable = true;
      package = pkgs."firefox-bin"; # official firefox dist
    };
    uwsm.enable = true;
    steam.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

}

{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    usbutils
    gparted

    wlrctl
    xdg-utils
    hyprpolkitagent
    hyprcursor
    hyprpaper

    dunst

    graphite-cursors

    geekbench

    prismlauncher
  ];

  programs = {
    steam.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
          inhibit_screensaver = 0;
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
}

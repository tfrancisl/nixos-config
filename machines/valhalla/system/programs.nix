{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    usbutils
    gparted

    wlrctl
    xdg-utils
    hyprpolkitagent

    dunst

    qpwgraph
    pavucontrol

    graphite-cursors
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

  services.pulseaudio.enable = false;
  services.pipewire.enable = true;
  security.rtkit.enable = true;
}

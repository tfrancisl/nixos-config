# Catchall and new settings
{pkgs, ...}: let
  # Helper function to create Hyprland variable for a binary
  binVar = pkg: binary: {"\$${binary}" = "${pkg}/bin/${binary}";};

  # Binary variables for workspace toggle keybind
  bins =
    (binVar pkgs.alacritty "alacritty")
    // (binVar pkgs.nnn "nnn")
    // (binVar pkgs.wofi "wofi")
    // (binVar pkgs.zed-editor "zeditor")
    // (binVar pkgs.uwsm "uwsm");
in {
  environment.systemPackages = with pkgs; [
    gparted
    wlrctl
    xdg-utils
    hyprpolkitagent
    dunst
    qpwgraph
    pavucontrol
    graphite-cursors
    quickshell
    kdePackages.qtdeclarative # provides qmlls for zed
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.hyprland.settings =
    bins
    // {
      "$super_mod" = "SUPER";
      "$terminal" = "$alacritty";
      "$file_manager" = "$terminal -e $nnn";
      "$menu" = "$wofi --show drun";

      input = {
        kb_layout = "us";

        repeat_delay = 300;
        repeat_rate = 99;

        follow_mouse = 1;
        off_window_axis_events = 2;

        # range is [-1.0, 1.0]; 0 means no modification.
        sensitivity = 0;
      };

      env = [
        "EDITOR,$zeditor"
        "HYPRCURSOR_THEME,graphite-light"
        "HYPRCURSOR_SIZE,28"
        "XCURSOR_THEME,graphite-light"
        "XCURSOR_SIZE,28"
      ];

      exec-once = [
        "$uwsm finalize"
      ];

      monitor = [
        # DP-3 is an ultrawide 2K, max 180 Hz
        "DP-3, 3440x1440@180, 1920x0, 1"
        # DP-1 is a standard 1080p, max 240 Hz -- set to 75 as 2ndary monitor
        "DP-1, 1920x1080@75, 0x0, 1"
      ];
    };
}

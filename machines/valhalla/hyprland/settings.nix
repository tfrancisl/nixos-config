# Catchall and new settings
{pkgs, ...}: let
  # Helper function to create Hyprland variable for a binary
  binVar = pkg: binary: {"\$${binary}" = "${pkg}/bin/${binary}";};

  # Binary variables for workspace toggle keybind
  bins =
    (binVar pkgs.alacritty "alacritty")
    // (binVar pkgs.nnn "nnn")
    // (binVar pkgs.wofi "wofi")
    // (binVar pkgs.zed-editor "zeditor");
in {
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

      monitor = [
        "DP-3, 1920x1080@240, 1920x0, 1"
        "HDMI-A-1, 1920x1080@60, 0x0, 1"
      ];
    };
}

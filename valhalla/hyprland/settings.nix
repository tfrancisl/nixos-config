# Catchall and new settings

{
  programs.hyprland.settings = {

    monitor = [
      "DP-3, 1920x1080@240, 1920x0, 1"
      "HDMI-A-1, 1920x1080@60, 0x0, 1"
    ];

    "$super_mod" = "SUPER";
    "$terminal" = "alacritty";
    "$file_manager" = "$terminal -e nnn";
    "$menu" = "wofi --show drun";

    input = {
      kb_layout = "us";
      repeat_delay = 250;
      repeat_rate = 35;

      follow_mouse = 1;
      off_window_axis_events = 2;

      # range is [-1.0, 1.0]; 0 means no modification.
      sensitivity = 0;

      touchpad = {
        natural_scroll = false;
      };
    };

    env = [
      "EDITOR,$editor"
      "HYPRCURSOR_THEME,graphite-light"
      "HYPRCURSOR_SIZE,28"
      "XCURSOR_THEME,graphite-light"
      "XCURSOR_SIZE,28"
    ];
  };
}

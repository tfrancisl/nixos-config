{
  programs.hyprland.settings = {
    workspace = [
      # turn off gaps when tiled window count = 1
      "w[tv1], gapsout:0, gapsin:0"
    ];
    windowrule = [
      # turn down borders on solo windows
      "match:workspace w[tv1], match:float false, border_size 4"

      "match:class ^(Alacritty)$, float on, move 0.125*monitor_w 0.125*monitor_h, size 0.5*monitor_w 0.5*monitor_h, keep_aspect_ratio on, opacity 1.0 0.34"

      # floating have special active/inactive border
      "match:float true, border_color rgb(111212)"
      "match:float true, match:focus true, border_color rgb(4122d5)"

      "match:class .*, suppress_event maximize"
    ];
  };
}

{
  programs.hyprland.settings = {
    workspace = [
      # turn off gaps when tiled window count = 1
      "w[tv1], gapsout:0, gapsin:0"
    ];
    windowrule = [
      # turn down borders on solo windows
      "match:workspace w[tv1], match:float false, border_size 4"

      # Alacritty starts floating and at 16:9 and 50%
      "match:class ^(Alacritty)$, float on, opacity 1.0 0.34, size 0.5*(16/9)*monitor_h 0.5*monitor_h, move 0.2*monitor_w 0.2*monitor_h, keep_aspect_ratio on"

      # floating have special active/inactive border
      "match:float true, match:focus false, border_color rgb(111212)"
      "match:float true, match:focus true, border_color rgb(4122d5)"
      # any window which starts floating is 16:9 and 50% size; except steam windows -- dropdowns in UI are floating windows :)
      "match:float true, match:class negate:[Ss]team, size 0.5*(16/9)*monitor_h 0.5*monitor_h, move 0.2*monitor_w 0.2*monitor_h, keep_aspect_ratio on"

      "match:class .*, suppress_event maximize"
    ];
  };
}

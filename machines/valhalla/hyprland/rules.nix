{
  programs.hyprland.settings = {
    workspace = [
      # turn off gaps when tiled window count = 1
      "w[tv1], gapsout:0, gapsin:0"
    ];
    windowrule = [
      # turn off borders on solo windows
      "match:workspace w[tv1], match:float false, border_size 0, rounding 0"

      # floating have special active/inactive border
      "match:float true, match:focus false, border_color rgba(111212ff) rgba(111212ff)"
      "match:float true, match:focus true, border_color rgba(4122d5ff) rgba(15f33dff)"

      "match:class ^(Alacritty)$, float on, move 12.5% 12.5%, move 12.5% 12.5%, keep_aspect_ratio on, opacity 1.0 0.34"

      "match:class .*, suppress_event maximize"
    ];
  };
}

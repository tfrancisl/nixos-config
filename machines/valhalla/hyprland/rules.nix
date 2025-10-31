{
  programs.hyprland.settings = {
    windowrulev2 = [
      # floating have special active/inactive border
      "bordercolor rgba(111212ff) rgba(111212ff), floating:1"
      "bordercolor rgba(4122d5ff) rgba(15f33dff), focus:1, floating:1"
      # alacritty always floats
      "float, class:^(Alacritty)$"
      "size 50% 50%, class:^(Alacritty)$"
      "move 12.5% 12.5%, class:^(Alacritty)$"
      "keepaspectratio, class:^(Alacritty)$"
      "opacity 1.0 0.34, class:^(Alacritty)$"
      # no maxim pls
      "suppressevent maximize, class:.*"
    ];
    workspace = [
      # turn off gaps when tiled window count = 1
      "w[tv1], gapsout:0, gapsin:0"
    ];
    windowrule = [
      # turn off borders on solo windows
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "rounding 0, floating:0, onworkspace:w[tv1]"
    ];
  };
}

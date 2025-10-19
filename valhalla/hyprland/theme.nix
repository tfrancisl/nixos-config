{
  programs.hyprland.settings = {

    general = {
      gaps_in = 4;
      gaps_out = 2;

      border_size = 6;

      "col.active_border" = "rgba(41d8d5ff) rgba(15f88dff)";
      "col.inactive_border" = "rgba(680726ff) rgba(680726ff)";

      resize_on_border = false;
      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 5;
      active_opacity = 1.0;
      fullscreen_opacity = 1.0;
      inactive_opacity = 0.935;
      blur.enabled = false;
      shadow.enabled = false;
    };

    animations.enabled = true;
    bezier = "fastCurve, 0.25, 0.65, 0, 1.0";
    animation = [
      "windowsIn, 1, 8, fastCurve"
      "windowsOut, 1, 8, fastCurve"
      "windowsMove, 1, 8, fastCurve"
      "border, 1, 8, fastCurve"
      "borderangle, 1, 250, default, loop"
      "fade, 1, 2.5, fastCurve"
    ];
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };

    cursor = {
      zoom_factor = 1;
      zoom_rigid = false;
      hotspot_padding = 1;
    };

    dwindle = {
      pseudotile = false;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };
  };
}

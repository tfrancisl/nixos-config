# Catchall and new settings
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
  inherit (import ./lib.nix lib) toHyprlang;

  # Script to toggle active window between workspaces 1 and 2
  # probably could be simpler/better
  toggleWorkspaceScript = pkgs.writeShellScript "toggle-workspace" ''
    current_workspace=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '.workspace.id')

    if [ "$current_workspace" -eq 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 2
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 1
    fi
  '';

  # Helper function to create Hyprland variable for a binary
  binVar = pkg: binary: {"\$${binary}" = "${pkg}/bin/${binary}";};

  # Binary variables for workspace toggle keybind
  bins =
    (binVar pkgs.alacritty "alacritty")
    // (binVar pkgs.nnn "nnn")
    // (binVar pkgs.wofi "wofi");
in {
  config = lib.mkIf config.acme.hyprland.enable {
    # these pkgs should be in a "graphical env" space, not hypr specifically
    environment.systemPackages = with pkgs; [
      gparted
      dunst
      pavucontrol
      graphite-cursors
    ];

    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = ["man:systemd.special(7)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    environment.sessionVariables = {
      # these five could be in a "wayland fixes" section
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      # fix java bug on tiling wm's / compositors
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # enable java anti aliasing
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";

      # cursor stuff could be elsewhere
      HYPRCURSOR_THEME = "graphite-light";
      HYPRCURSOR_SIZE = 32;
      XCURSOR_THEME = "graphite-light";
      XCURSOR_SIZE = 32;
    };

    hjem.users.${username} = {
      # fixes some apps cursor theme
      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI {};
        value = {
          "Icon Theme".Inherits = "graphite-light";
        };
      };
    };

    # Could not get this to work using hjem.users.${username}.xdg.config.files
    # Resorting to etc conf file. This probably has something to do with the hyprland repo module
    environment.etc."xdg/hypr/hyprland.conf".text = let
      config =
        bins
        // {
          "$super_mod" = "SUPER";
          "$file_manager" = "$alacritty -e $nnn";
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
          exec-once = [
            "dbus-update-activation-environment --systemd --all"
            "systemctl --user start hyprland-session.target"
          ];
          # in the rare case I need to kill Hyprland
          exec-shutdown = [
            "systemctl --user stop hyprland-session.target"
          ];

          "monitorv2[desc:Microstep MAG 346CQ DD7M045200043]" = {
            mode = "3440x1440@180";
            position = "1920x0";
            scale = 1;
            bitdepth = 10;
            supports_hdr = 1;
            supports_wide_color = 1;
            cm = "hdr";
            sdr_min_luminance = 0.005;
            sdr_max_luminance = 275;
            sdrsaturation = 1.25;
            sdrbrightness = 0.97;
          };
          "monitorv2[desc:Acer Technologies ED270 X TKXAA0013W01]" = {
            mode = "1920x1080@60";
            position = "0x0";
            scale = 1;
            supports_hdr = -1;
          };

          render = {
            direct_scanout = 0;
            cm_sdr_eotf = 2;
          };
          quirks = {
            prefer_hdr = 1;
          };
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
            enable_swallow = 1; # Enable window swallowing
            swallow_regex = "Alacritty"; # Make Alacritty swallow executed windows
            swallow_exception_regex = "Alacritty"; # Make Alacritty not swallow itself
            middle_click_paste = false;
          };
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
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
          bind = [
            "$super_mod, C, killactive,"
            "$super_mod, M, exit,"
            "$super_mod, Q, exec, $alacritty"
            "$super_mod, E, exec, $file_manager"
            "$super_mod, R, exec, $menu"
            "$super_mod, F, fullscreen"
            "$super_mod, V, togglefloating,"
            "$super_mod, T, exec, ${toggleWorkspaceScript}"
            # super+shift+N to move to workspace
            "$super_mod SHIFT, 1, movetoworkspace, 1"
            "$super_mod SHIFT, 2, movetoworkspace, 2"
            # super+arrows to move focus
            "$super_mod, left, movefocus, l"
            "$super_mod, right, movefocus, r"
            "$super_mod, up, movefocus, u"
            "$super_mod, down, movefocus, d"
          ];
          bindm = [
            "$super_mod, mouse:272, movewindow"
            "$super_mod, mouse:273, resizewindow"
          ];
        };
    in
      toHyprlang {} config;
  };
}

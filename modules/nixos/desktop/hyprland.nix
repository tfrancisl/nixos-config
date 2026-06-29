{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.acme.hyprland;
  inherit (config.acme.core) username;
in
{
  options.acme = {
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf cfg.enable {
    acme.desktop.enable = lib.mkForce true;
    programs.hyprland.enable = lib.mkForce true;

    acme.greeter.autologinCommand = "/run/current-system/sw/bin/start-hyprland";

    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    environment.sessionVariables = {
      HYPRCURSOR_THEME = "graphite-light";
      HYPRCURSOR_SIZE = 32;
    };

    hjem.users.${username} = {
      xdg.config.files."hypr/hyprland.lua".text = ''
        -- https://wiki.hypr.land/Configuring/Start/

        --------------------
        ---- MY PROGRAMS ----
        --------------------

        local mainMod              = "SUPER"
        local alacritty            = "${pkgs.alacritty}/bin/alacritty"
        local wofi                 = "${pkgs.wofi}/bin/wofi"

        -------------------
        ---- AUTOSTART ----
        -------------------

        hl.on("hyprland.start", function()
            hl.exec_cmd("dbus-update-activation-environment --systemd --all")
            hl.exec_cmd("systemctl --user start hyprland-session.target")
        end)

        hl.on("hyprland.shutdown", function()
            hl.exec_cmd("systemctl --user stop hyprland-session.target")
        end)

        ------------------
        ---- MONITORS ----
        ------------------

        hl.monitor({
            output       = "desc:Microstep MAG 346CQ DD7M045200043",
            mode         = "3440x1440@180",
            position     = "1920x0",
            scale        = 1,
            bitdepth     = 10,
            supports_hdr = -1,
        })

        hl.monitor({
            output       = "desc:Acer Technologies ED270 X TKXAA0013W01",
            mode         = "1920x1080@60",
            position     = "0x0",
            scale        = 1,
            supports_hdr = -1,
        })

        -----------------------
        ---- LOOK AND FEEL ----
        -----------------------

        hl.config({
            render = {
                direct_scanout = 0,
                cm_auto_hdr    = 0,
            },
            general = {
                gaps_in      = 4,
                gaps_out     = 2,
                float_gaps   = 2,
                border_size  = 4,
                col = {
                    active_border   = { colors = {"rgba(41d8d5ff)", "rgba(15f88dff)"}, angle = 45 },
                    inactive_border = "rgba(680726ff)",
                },
                resize_on_border = false,
                allow_tearing    = false,
                layout           = "dwindle",
            },
            decoration = {
                rounding           = 5,
                active_opacity     = 1.0,
                fullscreen_opacity = 1.0,
                inactive_opacity   = 0.935,
                blur   = { enabled = false },
                shadow = { enabled = false },
            },
            animations = { enabled = true },
            input = {
                kb_layout              = "us",
                repeat_delay           = 300,
                repeat_rate            = 99,
                follow_mouse           = 1,
                off_window_axis_events = 2,
                sensitivity            = 0,
            },
            misc = {
                disable_hyprland_logo     = true,
                disable_splash_rendering  = true,
                enable_swallow            = 1,
                swallow_regex             = "Alacritty",
                swallow_exception_regex   = "Alacritty",
                middle_click_paste        = false,
                layers_hog_keyboard_focus = false,
                on_focus_under_fullscreen = false,
            },
            ecosystem = {
                no_update_news  = true,
                no_donation_nag = true,
            },
            cursor = {
                default_monitor = "DP-3",
                zoom_factor     = 1,
                zoom_rigid      = false,
                hotspot_padding = 1,
            },
            dwindle = {
                preserve_split = true,
            },
            master = {
                new_status = "master",
            },
        })

        ---------------------
        ---- ANIMATIONS ----
        ---------------------

        hl.curve("fastCurve", { type = "bezier", points = { {0.25, 0.65}, {0, 1.0} } })

        hl.animation({ leaf = "windowsIn",   enabled = true, speed = 8,   bezier = "fastCurve" })
        hl.animation({ leaf = "windowsOut",  enabled = true, speed = 8,   bezier = "fastCurve" })
        hl.animation({ leaf = "windowsMove", enabled = true, speed = 8,   bezier = "fastCurve" })
        hl.animation({ leaf = "border",      enabled = true, speed = 8,   bezier = "fastCurve" })
        hl.animation({ leaf = "borderangle", enabled = true, speed = 80.0, bezier = "default", style = "loop" })
        hl.animation({ leaf = "fade",        enabled = true, speed = 2.5, bezier = "fastCurve" })

        --------------------------------
        ---- WINDOWS AND WORKSPACES ----
        --------------------------------

        hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })

        hl.window_rule({
            name        = "solo-border",
            match       = { workspace = "w[tv1]", float = false },
            border_size = 1,
        })

        hl.window_rule({
            name              = "alacritty-float",
            match             = { class = "^(Alacritty)$" },
            float             = true,
            opacity           = "1.0 0.34",
            size              = "0.5*(16/9)*monitor_h 0.5*monitor_h",
            move              = "0.2*monitor_w 0.2*monitor_h",
            keep_aspect_ratio = true,
        })

        hl.window_rule({
            name         = "float-inactive-border",
            match        = { float = true, focus = false },
            border_color = "rgb(111212)",
        })

        hl.window_rule({
            name         = "float-active-border",
            match        = { float = true, focus = true },
            border_color = "rgb(4122d5)",
        })

        hl.window_rule({
            name              = "float-size",
            match             = { float = true, class = "negate:[Ss]team" },
            size              = "0.5*(16/9)*monitor_h 0.5*monitor_h",
            move              = "0.2*monitor_w 0.2*monitor_h",
            keep_aspect_ratio = true,
        })

        hl.window_rule({
            name           = "suppress-maximize",
            match          = { class = ".*" },
            suppress_event = "maximize",
        })

        ---------------------
        ---- KEYBINDINGS ----
        ---------------------

        hl.bind(mainMod .. " + C", hl.dsp.window.close())
        hl.bind(mainMod .. " + M", hl.dsp.exit())
        hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
        hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(alacritty))
        hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(wofi .. " --show drun"))
        hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("screenshot"))

        hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
        hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
      '';
    };
  };
}

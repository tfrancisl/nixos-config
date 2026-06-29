{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.acme.mangowc;
  inherit (config.acme.core) username;

  startMango = pkgs.writeShellScript "start-mango" ''
    dbus-update-activation-environment --systemd --all
    systemctl --user start mango-session.target
    ${pkgs.mangowc}/bin/mango
    systemctl --user stop mango-session.target
  '';
in
{
  options.acme = {
    mangowc.enable = lib.mkEnableOption "mangowc";
  };

  config = lib.mkIf cfg.enable {
    programs.mangowc.enable = lib.mkForce true;
    acme.desktop.enable = lib.mkForce true;
    acme.greeter.autologinCommand = "${startMango}";

    systemd.user.targets.mango-session = {
      description = "MangoWC compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    hjem.users.${username} = {
      packages = [ ];
      xdg.config.files."mango/config.conf".text = ''
        # Monitor rules
        monitorrule=name:DP-3,width:3440,height:1440,refresh:180,x:1920,y:0,scale:1
        monitorrule=name:DP-1,width:1920,height:1080,refresh:60,x:0,y:0,scale:1

        # Window effects
        blur=0
        blur_layer=0
        shadows=0
        layer_shadows=0
        border_radius=5
        no_radius_when_single=0
        focused_opacity=1.0
        unfocused_opacity=0.935

        # Animations (matching fastCurve bezier)
        animations=1
        layer_animations=1
        animation_type_open=slide
        animation_type_close=slide
        animation_fade_in=1
        animation_fade_out=1
        tag_animation_direction=1
        animation_duration_open=300
        animation_duration_close=400
        animation_duration_move=400
        animation_duration_tag=350
        animation_duration_focus=0
        animation_curve_open=0.25,0.65,0,1.0
        animation_curve_move=0.25,0.65,0,1.0
        animation_curve_tag=0.25,0.65,0,1.0
        animation_curve_close=0.25,0.65,0,1.0

        # Dwindle layout
        dwindle_preserve_split=1
        dwindle_smart_split=0
        dwindle_drop_simple_split=1

        # Misc
        sloppyfocus=1
        warpcursor=1
        focus_on_activate=1
        smartgaps=1
        no_border_when_single=0

        # Keyboard
        repeat_rate=99
        repeat_delay=300
        xkb_rules_layout=us
        cursor_size=32

        # Appearance
        gappih=4
        gappiv=4
        gappoh=2
        gappov=2
        borderpx=4
        bordercolor=0x680726ff
        focuscolor=0x41d8d5ff

        # All tags use dwindle
        tagrule=id:1,layout_name:dwindle
        tagrule=id:2,layout_name:dwindle
        tagrule=id:3,layout_name:dwindle
        tagrule=id:4,layout_name:dwindle
        tagrule=id:5,layout_name:dwindle
        tagrule=id:6,layout_name:dwindle
        tagrule=id:7,layout_name:dwindle
        tagrule=id:8,layout_name:dwindle
        tagrule=id:9,layout_name:dwindle

        # Key bindings
        bind=SUPER,c,killclient,
        bind=SUPER,m,quit
        bind=SUPER,f,togglefullscreen,
        bind=SUPER,v,togglefloating,
        bind=SUPER,q,spawn,${pkgs.alacritty}/bin/alacritty
        bind=SUPER,r,spawn,${pkgs.wofi}/bin/wofi --show drun
        bind=SUPER,s,spawn,screenshot
        bind=SUPER+SHIFT,r,reload_config

        bind=SUPER,Left,focusdir,left
        bind=SUPER,Right,focusdir,right
        bind=SUPER,Up,focusdir,up
        bind=SUPER,Down,focusdir,down

        mousebind=SUPER,btn_left,moveresize,curmove
        mousebind=SUPER,btn_right,moveresize,curresize
      '';
    };
  };
}

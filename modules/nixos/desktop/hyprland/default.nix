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

        local mainMod   = "SUPER"
        local alacritty = "${pkgs.alacritty}/bin/alacritty"
        local wofi      = "${pkgs.wofi}/bin/wofi"

      ''
      + builtins.readFile ./hyprland.lua;
    };
  };
}

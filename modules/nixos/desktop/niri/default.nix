{
  config,
  pkgs,
  pkgs',
  lib,
  ...
}:
let
  cfg = config.acme.niri;
  inherit (config.acme.core) username;
  inherit (config.acme) hjemImpureSource;
in
{
  options.acme = {
    niri.enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable {
    acme.desktop.enable = lib.mkForce true;
    programs.niri.enable = lib.mkForce true;

    # niri-session runs niri as a systemd user service bound to graphical-session.target
    acme.greeter.autologinCommand = "/run/current-system/sw/bin/niri-session";

    hjem.users.${username} = {
      # niri starts this on demand for X11 clients
      packages = [ pkgs.xwayland-satellite ];
      xdg.config.files = {
        "niri/config.kdl".source = hjemImpureSource ./niri.kdl;
        # binds that need program paths; `include "nix.kdl"`
        "niri/nix.kdl".text = ''
          binds {
              Mod+Q { spawn "${lib.getExe pkgs.alacritty}"; }
              Mod+R { spawn "${lib.getExe pkgs.wofi}" "--show" "drun"; }
              Mod+S { spawn "${lib.getExe pkgs'.waylandScreenshot}"; }
          }
        '';
      };
    };
  };
}

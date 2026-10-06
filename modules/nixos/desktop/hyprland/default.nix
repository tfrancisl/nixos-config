{
  config,
  pkgs,
  pkgs',
  lib,
  ...
}:
let
  cfg = config.acme.hyprland;
  inherit (config.acme.core) username;
  inherit (config.acme) hjemImpureSource;
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

    hjem.users.${username}.xdg.config.files =
      lib.genAttrs' (lib.filter (lib.hasSuffix ".lua") (lib.attrNames (builtins.readDir ./.))) (
        name:
        lib.nameValuePair "hypr/${name}" {
          source = hjemImpureSource ./${name};
        }
      )
      // {
        # program paths shared with the lua files; `require("nix")`
        "hypr/nix.lua".text = ''
          return {
            terminal = "${lib.getExe pkgs.alacritty}",
            launcher = "${lib.getExe pkgs.wofi} --show drun",
            screenshot = "${lib.getExe pkgs'.waylandScreenshot}",
          }
        '';
      };
  };
}

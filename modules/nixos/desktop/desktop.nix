{
  config,
  pkgs,
  pkgs',
  lib,
  ...
}:
let
  cfg = config.acme.desktop;
  inherit (config.acme.core) username;

  screenshotTool = pkgs'.waylandScreenshot;
in
{
  options.acme = {
    desktop.enable = lib.mkEnableOption "Desktop";
  };

  config = lib.mkIf cfg.enable {

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";

      _JAVA_AWT_WM_NONREPARENTING = "1";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";

      XCURSOR_THEME = "graphite-light";
      XCURSOR_SIZE = 32;
    };

    hjem.users.${username} = {
      packages = [
        pkgs.gparted
        pkgs.dunst
        pkgs.pavucontrol
        pkgs.graphite-cursors
        pkgs.ghostty
        screenshotTool
      ];
      # fixes some apps cursor theme
      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI { };
        value = {
          "Icon Theme".Inherits = "graphite-light";
        };
      };
    };
  };
}

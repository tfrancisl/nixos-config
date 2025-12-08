{
  config,
  lib,
  ...
}: let
  session = {
    command = "${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland-uwsm.desktop";
    user = config.system_user.username;
  };
in
  lib.mkIf (config.greeting.mode == "instalogin") {
    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };
  }

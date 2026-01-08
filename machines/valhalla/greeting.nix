{config, ...}: let
  default_session = {
    command = "/run/current-system/sw/bin/start-hyprland";
    user = config.system_user.username;
  };
in {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = default_session;
      initial_session = default_session;
    };
  };
}

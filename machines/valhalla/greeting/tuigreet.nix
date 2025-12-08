{
  pkgs,
  config,
  lib,
  ...
}: let
  session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --remember";
    user = "greeter";
  };
in
  lib.mkIf (config.greeting.mode == "tuigreet") {
    environment.systemPackages = [pkgs.tuigreet];

    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    users.users.greeter = {
      isNormalUser = false;
      description = "greetd greeter user";
      extraGroups = [
        "video"
        "audio"
      ];
      linger = true;
    };
  }

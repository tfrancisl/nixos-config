{
  config,
  lib,
  ...
}: let
  default_session = {
    command = config.acme.greeter.autologin_command;
    user = config.acme.core.username;
  };
in {
  options.acme = {
    greeter = {
      enable = lib.mkEnableOption "greeter";
      autologin_command = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.acme.greeter.enable {
    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        inherit default_session;
        initial_session = default_session;
      };
    };
  };
}

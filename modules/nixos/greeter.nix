{
  config,
  lib,
  ...
}: let
  cfg = config.acme.greeter;
  defaultSession = {
    command = cfg.autologinCommand;
    user = config.acme.core.username;
  };
in {
  options.acme = {
    greeter = {
      enable = lib.mkEnableOption "greeter";
      autologinCommand = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = defaultSession;
        initial_session = defaultSession;
      };
    };
  };
}

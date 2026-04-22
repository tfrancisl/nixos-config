{
  config,
  lib,
  ...
}:
let
  cfg = config.acme.greeter;
  defaultSession = {
    command = cfg.autologinCommand;
    user = config.acme.core.username;
  };
in
{
  options.acme = {
    greeter = {
      autologinCommand = lib.mkOption {
        type = lib.types.str;
        default = "/run/current-system/sw/bin/fish";
      };
    };
  };

  config = {
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

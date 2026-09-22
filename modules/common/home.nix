{
  lib,
  config,
  pkgs,
  pkgs',
  hjemImpureModule,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  options.acme = {
    core.username = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = {
    hjem = {
      cli.package = pkgs'.hjemCli;
      linker = pkgs.smfh;
      clobberByDefault = true;
      users.${username} = {
        enable = true;
        impure = {
          enable = true;

          dotsDir = "${./../..}";
          dotsDirImpure = "${config.environment.variables.NH_FILE}";
        };
      };
      extraModules = [ hjemImpureModule ];
    };
    environment.variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    programs.fish.enable = true;
    time.timeZone = "America/New_York"; # EST/EDT
  };
}

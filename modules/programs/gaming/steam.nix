{
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    gaming.steam.enable = lib.mkOption {
      default = config.acme.gaming.enable;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.acme.gaming.steam.enable {
    users.users.${username} = {
      extraGroups = [
        "gamemode"
      ];
    };
    programs = {
      steam.enable = true;
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
            inhibit_screensaver = 0;
          };
        };
      };
    };
  };
}

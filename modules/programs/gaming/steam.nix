{
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    gaming.steam.enable = lib.mkEnableOption "steam";
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

{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  config = {
    hjem.users.${username} = {
      packages = [
        (pkgs.discord.override {
          # we disable updates in settings.json
          disableUpdates = false;
          withTTS = false;
          enableAutoscroll = true;
        })
      ];
      xdg.config.files = {
        "discord/settings.json" = {
          generator = lib.generators.toJSON {};
          value = {
            SKIP_HOST_UPDATE = true;
            OPEN_ON_STARTUP = false;
            enableHardwareAcceleration = true;
          };
        };
      };
    };
  };
}

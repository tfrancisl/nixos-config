{
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.gaming.username;
in {
  hjem.users.${username} = {
    packages = [
      (pkgs.discord.override {
        # we disable updates in settings.json
        disableUpdates = false;
        withTTS = false;
        enableAutoscroll = true;
      })
    ];
    files = {
      ".config/discord/settings.json" = {
        generator = lib.generators.toJSON {};
        value = {
          SKIP_HOST_UPDATE = true;
          OPEN_ON_STARTUP = false;
          enableHardwareAcceleration = true;
        };
      };
    };
  };
}

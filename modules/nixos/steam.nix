{
  pkgs,
  config,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
    users.users.${username} = {
      extraGroups = [
        "gamemode"
      ];
    };
    hjem.users.${username} = {
      xdg.data.files."Steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads 4
      '';
    };

    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
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

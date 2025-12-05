{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.gaming.username;
in {
  options.gaming.username = lib.mkOption {type = lib.types.str;};

  config = {
    users.users.${username} = {
      extraGroups = [
        "gamemode"
      ];
      packages = with pkgs; [
        lunar-client
        wofi
        discord
        spotify
        r2modman
        prismlauncher
      ];
    };
  };

  imports = [
    ./steam.nix
  ];
}

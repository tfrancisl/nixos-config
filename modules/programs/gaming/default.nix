{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    gaming.enable = lib.mkEnableOption "gaming";
  };
  config = lib.mkIf config.acme.gaming.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        lunar-client
        wofi
        spotify
        r2modman
        prismlauncher
      ];
    };
  };
  imports = [
    ./steam.nix
    ./discord.nix
  ];
}

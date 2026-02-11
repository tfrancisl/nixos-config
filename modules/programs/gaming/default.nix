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
        teamspeak6-client
      ];
    };

    boot.kernelModules = [
      "ntsync"
    ];
    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0644"
    '';
    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = "1";
      "WAYLANDDRV_PRIMARY_MONITOR" = "DP-3";
      "PROTON_USE_WOW64" = "1";
    };
  };
  imports = [
    ./steam.nix
    ./discord.nix
  ];
}

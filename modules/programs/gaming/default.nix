{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.acme.gaming;
  inherit (config.acme.core) username;
in {
  options.acme = {
    gaming.enable = lib.mkEnableOption "gaming";
  };
  config = lib.mkIf cfg.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        lunar-client
        wofi
        spotify
        r2modman
        balatro-mod-manager
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

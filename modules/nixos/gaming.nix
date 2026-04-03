{
  config,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
in {
  config = {
    hjem.users.${username} = {
      packages = with pkgs; [
        rivalcfg # CLI for SteelSeries mouse hardware config
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
}

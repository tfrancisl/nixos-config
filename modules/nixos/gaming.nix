{
  config,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
in {
  config = {
    hjem.users.${username} = {
      packages = [
        pkgs.rivalcfg # CLI for SteelSeries mouse hardware config
        pkgs.lunar-client
        pkgs.wofi
        pkgs.spotify
        pkgs.r2modman
        pkgs.balatro-mod-manager
        pkgs.prismlauncher
        pkgs.teamspeak6-client
      ];
    };

    boot.kernelModules = [
      "ntsync"
    ];
    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0644"
    '';
    programs.mangohud.enable = true;

    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = "1";
      "WAYLANDDRV_PRIMARY_MONITOR" = "DP-3";
      "PROTON_USE_WOW64" = "1";
      "VKD3D_CONFIG" = "dxr11";
    };
  };
}

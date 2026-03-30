{
  config,
  lib,
  ...
}: let
  cfg = config.acme.network;
in {
  options.acme = {
    network = {
      enable = lib.mkEnableOption "network";
      hostname = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = [
      "bluetooth"
      "iwlwifi"
    ];
    networking = {
      wireless.enable = false;
      hostName = cfg.hostname;
      networkmanager.enable = false;
      useNetworkd = true;
      useDHCP = true;
    };
    systemd.network.enable = true;
  };
}

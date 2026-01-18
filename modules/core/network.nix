{
  config,
  lib,
  ...
}: {
  options.acme = {
    network = {
      enable = lib.mkEnableOption "network";
      hostname = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf config.acme.network.enable {
    boot.blacklistedKernelModules = [
      "bluetooth"
      "iwlwifi"
    ];
    networking = {
      wireless.enable = false;
      hostName = config.acme.network.hostname;
      networkmanager.enable = false;
      useNetworkd = true;
      useDHCP = true;
    };
    systemd.network.enable = true;
  };
}

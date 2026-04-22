{
  config,
  lib,
  ...
}:
let
  cfg = config.acme.network;
in
{
  options.acme = {
    network = {
      hostname = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = {
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
      nftables.enable = true;
    };
    systemd.network.enable = true;
  };
}

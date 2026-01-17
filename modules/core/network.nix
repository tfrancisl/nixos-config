{lib, ...}: {
  config = {
    networking = {
      wireless.enable = lib.mkForce false;
      hostName = "valhalla";
      networkmanager.enable = lib.mkForce false;
      useNetworkd = lib.mkDefault true;
      useDHCP = lib.mkDefault true;
    };
    systemd.network.enable = true;
  };
}

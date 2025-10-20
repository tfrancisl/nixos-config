{ ... }:
{

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "valhalla";
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05"; # Do not change this!
}

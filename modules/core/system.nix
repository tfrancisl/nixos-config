{lib, ...}: {
  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/59dc666f-1a13-4028-a4a0-90dcf6333084";
        fsType = "ext4";
      };
      "/mnt/big_drive/" = {
        mountPoint = "/mnt/big_drive";
        device = "/dev/disk/by-uuid/db55e664-3ec1-4aac-bf63-486ab796b1d7";
        fsType = "ext4";
      };
    };

    swapDevices = [];

    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

    system.stateVersion = "25.05"; # Do not change this!
  };
}

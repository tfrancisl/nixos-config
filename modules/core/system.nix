{
  lib,
  pkgs,
  ...
}: {
  config = {
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = ["kvm-amd"];

    boot.kernel.sysctl = {
      # Taken from https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
      # SteamOS platform optimization
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "kernel.split_lock_mitigate" = 0;
      "vm.max_map_count" = 2147483642;
    };

    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = false;
    };

    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
    swapDevices = [];
    system.stateVersion = "25.05"; # Do not change this!
  };
}

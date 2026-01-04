{
  pkgs,
  config,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.kernel.sysctl = {
    # Taken from https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
    # SteamOS platform optimization
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
    "kernel.split_lock_mitigate" = 0;
    "vm.max_map_count" = 2147483642;
  };

  boot.blacklistedKernelModules = ["bluetooth" "iwlwifi"];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
  };

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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking = {
    wireless.enable = lib.mkForce false;
    hostName = "valhalla";
    networkmanager.enable = lib.mkForce false;
    useDHCP = lib.mkDefault true;
  };

  services.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    audio.enable = true;
    alsa.enable = lib.mkForce false;
    jack.enable = lib.mkForce false;
    extraConfig.pipewire = {
      "properties" = {
        default.clock.allowed-rates = [44100 48000 96000];
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };
  };
  security.rtkit.enable = true;

  system.stateVersion = "25.05"; # Do not change this!
}

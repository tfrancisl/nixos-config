{config, ...}: {
  config = {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = false;
        gsp.enable = config.hardware.nvidia.open;
        nvidiaSettings = false;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    boot = {
      # early load / early kms
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      blacklistedKernelModules = ["nouveau"];

      kernelParams = [
        "nvidia.NVreg_UsePageAttributeTable=1"
        "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
        "nvidia-modeset.disable_vrr_memclk_switch=1"
      ];
    };
  };
}

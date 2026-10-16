{ config, lib, ... }:
let
  cfg = config.acme.nvidia;
  isOpen = cfg.driver == "open";
in
{
  options.acme.nvidia = {
    driver = lib.mkOption {
      type = lib.types.enum [
        "proprietary"
        "open"
      ];
      default = "proprietary";
      description = ''
        Which NVIDIA kernel modules to use. Both use the same proprietary userspace
        (not nouveau/NVK); "open" swaps in the open-source kernel modules, which
        require GSP firmware.
      '';
    };
  };

  config = {
    # extra boot entry for trialing the open kernel modules alongside proprietary
    specialisation = lib.mkIf (!isOpen) {
      nvidia-open.configuration = {
        acme.nvidia.driver = lib.mkForce "open";
        system.nixos.tags = [ "nvidia-open" ];
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia = {
        open = isOpen;
        # open modules require GSP; proprietary keeps it off for lower latency
        gsp.enable = isOpen;
        nvidiaSettings = false;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        branch = "latest";
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
      blacklistedKernelModules = [ "nouveau" ];

      kernelParams = [
        "nvidia.NVreg_UsePageAttributeTable=1"
        "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
        "nvidia-modeset.disable_vrr_memclk_switch=1"
      ];
    };
  };
}

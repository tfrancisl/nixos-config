{
  config,
  lib,
  ...
}: {
  options.acme = {
    pipewire.enable = lib.mkEnableOption "pipewire";
  };

  config = lib.mkIf config.acme.pipewire.enable {
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
  };
}

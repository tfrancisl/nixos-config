{
  pkgs,
  lib,
  ...
}: {
  # environment.systemPackages = with pkgs; [
  #   qpwgraph
  #   pavucontrol
  # ];
  services.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "microphone" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "alsa_input.pci-0000_0b_00.3.analog-stereo";
                }
              ];
              actions = {
                update-props = {
                };
              };
            }
          ];
        };
        "headphone" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "alsa_card.pci-0000_0b_00.3";
                }
              ];

              actions = {
                update-props = {
                };
              };
            }
          ];
        };
      };
    };
  };
}

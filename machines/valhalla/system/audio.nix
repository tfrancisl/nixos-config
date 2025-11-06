{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qpwgraph
    pavucontrol
  ];
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}

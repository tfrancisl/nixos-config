_: {
  acme = {
    core = {
      username = "freya";
    };
    greeter = {
      enable = true;
      autologin_command = "/run/current-system/sw/bin/start-hyprland";
    };
    git.enable = true;
    pipewire.enable = true;
    hyprland.enable = true;
    firefox.enable = true;
    zed-editor.enable = true;
    gaming.enable = true;
    network = {
      enable = true;
      hostname = "valhalla";
    };
  };
}

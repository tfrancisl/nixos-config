_: {
  acme = {
    core = {
      username = "freya";
    };
    greeter = {
      enable = true;
      autologinCommand = "/run/current-system/sw/bin/start-hyprland";
    };
    git = {
      user = {
        name = "Tim Lester";
        email = "tfrancislester@gmail.com";
        username = "tfrancisl";
      };
    };
    pipewire.enable = true;
    hyprland.enable = true;
    firefox.enable = true;
    claude-code.enable = true;
    gaming.enable = true;
    network = {
      enable = true;
      hostname = "valhalla";
    };
  };
}

_: {
  acme = {
    core = {
      username = "freya";
    };
    greeter = {
      autologinCommand = "/run/current-system/sw/bin/start-hyprland";
    };
    git = {
      user = {
        name = "Tim Lester";
        email = "tfrancislester@gmail.com";
        username = "tfrancisl";
      };
    };
    hyprland.enable = true;
    noctalia.enable = true;
    claude-code.enable = true;
    network = {
      hostname = "valhalla";
    };
  };
}

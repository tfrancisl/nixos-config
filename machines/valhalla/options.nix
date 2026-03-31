_: {
  acme = {
    core = {
      username = "freya";
    };
    greeter = {
      enable = true;
      autologinCommand = "/run/current-system/sw/bin/start-hyprland";
    };
    git.enable = true;
    fzf-git-diff.enable = true;
    pipewire.enable = true;
    hyprland.enable = true;
    firefox.enable = true;
    zed-editor.enable = true;
    claude-code.enable = true;
    gaming.enable = true;
    network = {
      enable = true;
      hostname = "valhalla";
    };
  };
}

{...}: {
  acme = {
    core = {
      username = "hel";
    };
    greeter = {
      enable = true;
      autologin_command = "fish";
    };
    git.enable = true;
    pipewire.enable = false;
    hyprland.enable = false;
    firefox.enable = false;
    quickshell.enable = false;
    zed-editor.enable = false;
    gaming = {
      enable = false;
      steam.enable = false;
      discord.enable = false;
    };
  };
}

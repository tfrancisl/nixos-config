{...}: {
  programs = {
    steam.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
          inhibit_screensaver = 0;
        };
      };
    };
  };
}

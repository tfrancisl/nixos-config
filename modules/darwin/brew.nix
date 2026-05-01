_: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    brews = [
      { name = "databricks"; }
    ];
    casks = [
      {
        name = "firefox";
        args = {
          appdir = "~/my-apps/Applications";
        };
      }
      { name = "alacritty"; }
    ];
  };
}

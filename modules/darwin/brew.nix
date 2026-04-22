_: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    brews = [
      { name = "databricks"; }
      { name = "mise"; }
      { name = "usage"; }
      { name = "Arthur-Ficial/tap/apfel"; }
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
    taps = [
      { name = "Arthur-Ficial/tap"; }
    ];
  };
}

_: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    brews = [
      {name = "databricks";}
      {name = "mise";}
      {name = "usage";}
    ];
    casks = [
      {
        name = "firefox";
        args = {appdir = "~/my-apps/Applications";};
      }
      {name = "alacritty";}
    ];
  };
}

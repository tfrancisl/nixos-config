{ lib, ... }: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    taps =
      lib.map
        (tap: {
          name = tap;
          trusted = true;
          force_auto_update = true;
        })
        [
          "databricks/tap"
          "nikitabobko/tap"
        ];
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

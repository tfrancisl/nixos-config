{ ... }:
{
  config = {
    acme.zed.zed-bin = "~/my-apps/Applications/Zed.app/Contents/MacOS/cli";
    homebrew = {
      brews = [
      ];
      casks = [
        {
          name = "zed";
          args = {
            appdir = "~/my-apps/Applications";
          };
        }
      ];
      taps = [
      ];
    };
  };
}

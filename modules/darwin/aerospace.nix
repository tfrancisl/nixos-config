{config, ...}: let
  inherit (config.acme.core) username;
in {
  services.aerospace.enable = false; # managed with brew
  homebrew.casks = [{name = "aerospace";}];
  hjem.users.${username}.files.".config/aerospace/aerospace.toml".text = ''
    config-version = 2

    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    accordion-padding = 0

    default-root-container-layout = "tiles"
    default-root-container-orientation = "auto"

    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ]

    persistent-workspaces = [ "1", "2" ]
    automatically-unhide-macos-hidden-apps = true

    [key-mapping]
    preset = "qwerty"

    [workspace-to-monitor-force-assignment]
    1 = "main"
    2 = "secondary"

    [gaps]
    inner.horizontal = [ { monitor.secondary = 0 }, { monitor.main = 12 }, 0 ]
    inner.vertical = [ { monitor.secondary = 0 }, { monitor.main = 12 }, 0 ]
    outer.left = [ { monitor.secondary = 0 }, { monitor.main = 6 }, 0 ]
    outer.bottom = [ { monitor.secondary = 0 }, { monitor.main = 6 }, 0 ]
    outer.top = [ { monitor.secondary = 0 }, { monitor.main = 6 }, 0 ]
    outer.right = [ { monitor.secondary = 0 }, { monitor.main = 6 }, 0 ]

    [mode.main.binding]

    alt-shift-left = "move left"
    alt-shift-down = "move down"
    alt-shift-up = "move up"
    alt-shift-right = "move right"

    alt-minus = "resize smart -50"
    alt-equal = "resize smart +50"

    alt-1 = "workspace 1"
    alt-2 = "workspace 2"

    alt-shift-1 = "move-node-to-workspace 1"
    alt-shift-2 = "move-node-to-workspace 2"

    alt-tab = "workspace-back-and-forth"


    alt-shift-c = "reload-config"
    alt-v = "layout floating tiling" # like toggle float in hypr
    alt-f = "fullscreen"

    alt-left = ["focus left --boundaries all-monitors-outer-frame", "move-mouse window-force-center"]
    alt-right = ["focus right --boundaries all-monitors-outer-frame", "move-mouse window-force-center"]

  '';
}

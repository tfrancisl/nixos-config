{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.acme.hyprland;
  inherit (config.acme.core) username;

  inherit
    (lib)
    attrNames
    filterAttrs
    foldl
    generators
    partition
    ;

  inherit
    (lib.strings)
    concatMapStrings
    hasPrefix
    ;

  /**
  Convert a structured Nix attribute set into Hyprland's configuration format.

  This function takes a nested attribute set and converts it into Hyprland-compatible
  configuration syntax, supporting top, bottom, and regular command sections.

  Commands are flattened using the `flattenAttrs` function, and attributes are formatted as
  `key = value` pairs. Lists are expanded as duplicate keys to match Hyprland's expected format.

  Configuration:

  * `topCommandsPrefixes` - A list of prefixes to define **top** commands (default: `["$"]`).
  * `bottomCommandsPrefixes` - A list of prefixes to define **bottom** commands (default: `[]`).

  Attention:

  - The function ensures top commands appear **first** and bottom commands **last**.
  - The generated configuration is a **single string**, suitable for writing to a config file.
  - Lists are converted into multiple entries, ensuring compatibility with Hyprland.

  # Inputs

  Structured function argument:

  : topCommandsPrefixes (optional, default: `["$"]`)
    : A list of prefixes that define **top** commands. Any key starting with one of these
      prefixes will be placed at the beginning of the configuration.
  : bottomCommandsPrefixes (optional, default: `[]`)
    : A list of prefixes that define **bottom** commands. Any key starting with one of these
      prefixes will be placed at the end of the configuration.

  Value:

  : The attribute set to be converted to Hyprland configuration format.

  # Type

  ```
  toHyprlang :: AttrSet -> AttrSet -> String
  ```

  # Examples
  :::{.example}

  ```nix
  let
    config = {
      "$mod" = "SUPER";
      monitor = {
        "HDMI-A-1" = "1920x1080@60,0x0,1";
      };
      exec = [
        "waybar"
        "dunst"
      ];
    };
  in lib.toHyprlang {} config
  ```

  **Output:**
  ```nix
  "$mod = SUPER"
  "monitor:HDMI-A-1 = 1920x1080@60,0x0,1"
  "exec = waybar"
  "exec = dunst"
  ```

  :::
  */
  # Taken blindly from https://github.com/hyprwm/Hyprland/blob/main/nix/lib.nix
  toHyprlang = {
    topCommandsPrefixes ? ["$" "bezier"],
    bottomCommandsPrefixes ? [],
  }: attrs: let
    toHyprlang' = attrs: let
      # Specially configured `toKeyValue` generator with support for duplicate keys
      # and a legible key-value separator.
      mkCommands = generators.toKeyValue {
        mkKeyValue = generators.mkKeyValueDefault {} " = ";
        listsAsDuplicateKeys = true;
        indent = ""; # No indent, since we don't have nesting
      };

      # Flatten the attrset, combining keys in a "path" like `"a:b:c" = "x"`.
      # Uses `flattenAttrs` with a colon separator.
      commands = flattenAttrs (p: k: "${p}:${k}") attrs;

      # General filtering function to check if a key starts with any prefix in a given list.
      filterCommands = list: n:
        foldl (acc: prefix: acc || hasPrefix prefix n) false list;

      # Partition keys into top commands and the rest
      result = partition (filterCommands topCommandsPrefixes) (attrNames commands);
      topCommands = filterAttrs (n: _: builtins.elem n result.right) commands;
      remainingCommands = removeAttrs commands result.right;

      # Partition remaining commands into bottom commands and regular commands
      result2 = partition (filterCommands bottomCommandsPrefixes) result.wrong;
      bottomCommands = filterAttrs (n: _: builtins.elem n result2.right) remainingCommands;
      regularCommands = removeAttrs remainingCommands result2.right;
    in
      # Concatenate strings from mapping `mkCommands` over top, regular, and bottom commands.
      concatMapStrings mkCommands [
        topCommands
        regularCommands
        bottomCommands
      ];
  in
    toHyprlang' attrs;

  /**
  Flatten a nested attribute set into a flat attribute set, using a custom key separator function.

  This function recursively traverses a nested attribute set and produces a flat attribute set
  where keys are joined using a user-defined function (`pred`). It allows transforming deeply
  nested structures into a single-level attribute set while preserving key-value relationships.

  Configuration:

  * `pred` - A function `(string -> string -> string)` defining how keys should be concatenated.

  # Inputs

  Structured function argument:

  : pred (required)
    : A function that determines how parent and child keys should be combined into a single key.
      It takes a `prefix` (parent key) and `key` (current key) and returns the joined key.

  Value:

  : The nested attribute set to be flattened.

  # Type

  ```
  flattenAttrs :: (String -> String -> String) -> AttrSet -> AttrSet
  ```

  # Examples
  :::{.example}

  ```nix
  let
    nested = {
      a = "3";
      b = { c = "4"; d = "5"; };
    };

    separator = (prefix: key: "${prefix}.${key}");  # Use dot notation
  in lib.flattenAttrs separator nested
  ```

  **Output:**
  ```nix
  {
    "a" = "3";
    "b.c" = "4";
    "b.d" = "5";
  }
  ```

  :::

  */
  flattenAttrs = pred: attrs: let
    flattenAttrs' = prefix: attrs:
      builtins.foldl' (
        acc: key: let
          value = attrs.${key};
          newKey =
            if prefix == ""
            then key
            else pred prefix key;
        in
          acc
          // (
            if builtins.isAttrs value
            then flattenAttrs' newKey value
            else {"${newKey}" = value;}
          )
      ) {} (builtins.attrNames attrs);
  in
    flattenAttrs' "" attrs;

  # TODO do this differently
  screenshotTool =
    pkgs.callPackage
    "${self}/packages/screenshot.nix"
    {};

  # Script to toggle active window between workspaces 1 and 2
  # probably could be simpler/better
  toggleWorkspaceScript = pkgs.writeShellScript "toggle-workspace" ''
    current_workspace=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '.workspace.id')

    if [ "$current_workspace" -eq 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 2
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 1
    fi
  '';

  # Helper function to create Hyprland variable for a binary
  binVar = pkg: binary: {"\$${binary}" = "${pkg}/bin/${binary}";};

  # Binary variables for workspace toggle keybind
  bins =
    (binVar pkgs.alacritty "alacritty")
    // (binVar pkgs.wofi "wofi");
in {
  options.acme = {
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = lib.mkForce cfg.enable;
    };

    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = ["man:systemd.special(7)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    environment.sessionVariables = {
      # these five could be in a "wayland fixes" section
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      # fix java bug on tiling wm's / compositors
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # enable java anti aliasing
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";

      # cursor stuff could be elsewhere
      HYPRCURSOR_THEME = "graphite-light";
      HYPRCURSOR_SIZE = 32;
      XCURSOR_THEME = "graphite-light";
      XCURSOR_SIZE = 32;
    };

    hjem.users.${username} = {
      # these pkgs should be in a "graphical env" space, not hypr specifically
      packages = [
        pkgs.gparted
        pkgs.dunst
        pkgs.pavucontrol
        pkgs.graphite-cursors
        screenshotTool
      ];
      # fixes some apps cursor theme
      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI {};
        value = {
          "Icon Theme".Inherits = "graphite-light";
        };
      };
    };

    # Could not get this to work using hjem.users.${username}.xdg.config.files
    # Resorting to etc conf file.
    environment.etc."xdg/hypr/hyprland.conf".text = let
      config =
        bins
        // {
          "$super_mod" = "SUPER";

          input = {
            kb_layout = "us";

            repeat_delay = 300;
            repeat_rate = 99;

            follow_mouse = 1;
            off_window_axis_events = 2;

            # range is [-1.0, 1.0]; 0 means no modification.
            sensitivity = 0;
          };
          exec-once = [
            "dbus-update-activation-environment --systemd --all"
            "systemctl --user start hyprland-session.target"
          ];
          # in the rare case I need to kill Hyprland
          exec-shutdown = [
            "systemctl --user stop hyprland-session.target"
          ];

          "monitorv2[desc:Microstep MAG 346CQ DD7M045200043]" = {
            mode = "3440x1440@180";
            position = "1920x0";
            scale = 1;
            bitdepth = 10;
            supports_hdr = -1;
          };
          "monitorv2[desc:Acer Technologies ED270 X TKXAA0013W01]" = {
            mode = "1920x1080@60";
            position = "0x0";
            scale = 1;
            supports_hdr = -1;
          };
          render = {
            direct_scanout = 0;
            cm_auto_hdr = 0; # never try switching to hdr on full screen
          };
          workspace = [
            # turn off gaps when tiled window count = 1
            "w[tv1], gapsout:0, gapsin:0"
          ];
          windowrule = [
            # turn down borders on solo windows
            "match:workspace w[tv1], match:float false, border_size 1"

            # Alacritty starts floating and at 16:9 and 50%
            "match:class ^(Alacritty)$, float on, opacity 1.0 0.34, size 0.5*(16/9)*monitor_h 0.5*monitor_h, move 0.2*monitor_w 0.2*monitor_h, keep_aspect_ratio on"

            # floating have special active/inactive border
            "match:float true, match:focus false, border_color rgb(111212)"
            "match:float true, match:focus true, border_color rgb(4122d5)"
            # any window which starts floating is 16:9 and 50% size; except steam windows -- dropdowns in UI are floating windows :)
            "match:float true, match:class negate:[Ss]team, size 0.5*(16/9)*monitor_h 0.5*monitor_h, move 0.2*monitor_w 0.2*monitor_h, keep_aspect_ratio on"

            "match:class .*, suppress_event maximize"
          ];
          general = {
            gaps_in = 4;
            gaps_out = 2;
            float_gaps = 2;
            border_size = 4;
            "col.active_border" = "rgba(41d8d5ff) rgba(15f88dff)";
            "col.inactive_border" = "rgba(680726ff) rgba(680726ff)";
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };
          decoration = {
            rounding = 5;
            active_opacity = 1.0;
            fullscreen_opacity = 1.0;
            inactive_opacity = 0.935;
            blur.enabled = false;
            shadow.enabled = false;
          };
          animations.enabled = true;
          bezier = "fastCurve, 0.25, 0.65, 0, 1.0";
          animation = [
            "windowsIn, 1, 8, fastCurve"
            "windowsOut, 1, 8, fastCurve"
            "windowsMove, 1, 8, fastCurve"
            "border, 1, 8, fastCurve"
            "borderangle, 1, 250, default, loop"
            "fade, 1, 2.5, fastCurve"
          ];
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            enable_swallow = 1; # Enable window swallowing
            swallow_regex = "Alacritty"; # Make Alacritty swallow executed windows
            swallow_exception_regex = "Alacritty"; # Make Alacritty not swallow itself
            middle_click_paste = false;
            layers_hog_keyboard_focus = false; # wofi and such wont keep kb focus on mouse move
            on_focus_under_fullscreen = false; # games like CS2 and SMITE 2 will not tile if I open a web browser
          };
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
          cursor = {
            default_monitor = "DP-3";
            zoom_factor = 1;
            zoom_rigid = false;
            hotspot_padding = 1;
          };
          dwindle = {
            pseudotile = false;
            preserve_split = true;
          };
          master = {
            new_status = "master";
          };
          bind = [
            "$super_mod, C, killactive,"
            "$super_mod, M, exit,"
            "$super_mod, F, fullscreen"
            "$super_mod, V, togglefloating,"
            "$super_mod, T, exec, ${toggleWorkspaceScript}"

            "$super_mod, Q, exec, $alacritty"
            "$super_mod, R, exec, $wofi --show drun"
            "$super_mod, S, exec, screenshot"

            "$super_mod, left, movefocus, l"
            "$super_mod, right, movefocus, r"
            "$super_mod, up, movefocus, u"
            "$super_mod, down, movefocus, d"
          ];
          bindm = [
            # super+l or r mouse drag to move and resize
            "$super_mod, mouse:272, movewindow"
            "$super_mod, mouse:273, resizewindow"
          ];
        };
    in
      toHyprlang {} config;
  };
}

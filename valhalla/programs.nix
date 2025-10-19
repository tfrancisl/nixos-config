{ inputs, pkgs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  # Track non-free software explicitly
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "discord"
      "steam"
      "steam-unwrapped"
      "spotify"
      "firefox-bin"
      "firefox-bin-unwrapped"
      "geekbench"
    ];

  environment.systemPackages = with pkgs; [

    qpwgraph
    pavucontrol
    usbutils
    gparted

    wlrctl
    xdg-utils
    tuigreet
    hyprpolkitagent
    hyprcursor
    hyprpaper

    graphite-cursors

    geekbench

  ];

  programs = {
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    fish.enable = true;
    firefox = {
      enable = true;
      package = pkgs."firefox-bin"; # official firefox dist
    };
    steam.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;

}

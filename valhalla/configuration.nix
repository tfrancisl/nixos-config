{ pkgs, ... }:

{
  # Track non-free software explicitly
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "discord"
      "steam"
      "steam-unwrapped"
      "spotify"
      "firefox-bin"
      "firefox-bin-unwrapped"
      "geekbench"
    ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "valhalla";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York"; # EST/EDT
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.freya = {
    isNormalUser = true;
    description = "freya";
    initialPassword = "vm_changeme";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    # packages = with pkgs; [ ];
  };

  programs = {
    uwsm = {
      enable = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    fish.enable = true;
    firefox = {
      enable = true;
      package = pkgs."firefox-bin"; # official firefox dist
    };
    steam = {
      enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 2048;
      };
    };
  };

  # Greeting + start hyprland under UWSM
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F'";
        user = "greeter";
      };
    };
  };

  users.users.greeter = {
    isNormalUser = false;
    description = "greetd greeter user";
    extraGroups = [
      "video"
      "audio"
    ];
    linger = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    fish

    wofi
    dunst
    nnn
    htop

    zed-editor
    package-version-server # for zed
    nixd
    nixfmt-rfc-style

    qpwgraph
    pavucontrol
    usbutils
    gparted

    discord
    spotify

    git
    gh
    jq

    wlrctl
    xdg-utils
    tuigreet
    hyprpolkitagent
    hyprcursor
    hyprpaper
    hyprls

    graphite-cursors

    geekbench

    r2modman
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

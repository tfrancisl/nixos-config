{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    core.username = lib.mkOption {
      type = lib.types.str;
      default = "freya";
    };
  };

  config = {
    hjem = {
      linker = pkgs.smfh;
      clobberByDefault = true;

      users.${username}.enable = true;
    };
    xdg = {
      # we don't use these files
      autostart.enable = lib.mkForce false;
      portal = {
        enable = true;
        # seems to help steam wanting to use chromium for some reason
        xdgOpenUsePortal = true;
      };
    };

    users.users.${username} = {
      isNormalUser = true;
      description = "${username}'s user account";
      shell = pkgs.fish;
      # It would be ideal if you change this after logging in the first time.
      initialPassword = "cake";
      extraGroups = [
        "wheel"
        "input"
        "video"
        "audio"
      ];

      uid = 1000;
    };

    environment.sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    programs.fish.enable = true;
    time.timeZone = "America/New_York"; # EST/EDT
    i18n.defaultLocale = "en_US.UTF-8";
  };

  imports = [
    inputs.hjem.nixosModules.default
  ];
}

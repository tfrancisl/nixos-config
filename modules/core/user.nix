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
      users.${username}.enable = true;
    };
    users.users.${username} = {
      isNormalUser = true;
      description = "${username}'s user account";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "input"
        "video"
        "audio"
      ];

      uid = 1000;
    };
    programs.fish.enable = true;
    time.timeZone = "America/New_York"; # EST/EDT
    i18n.defaultLocale = "en_US.UTF-8";
  };

  imports = [
    inputs.hjem.nixosModules.default
  ];
}

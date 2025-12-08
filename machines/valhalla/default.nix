{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.system_user.username;
in {
  options.system_user.username = lib.mkOption {
    type = lib.types.str;
  };

  config = {
    users.users.${username} = {
      isNormalUser = true;
      description = "${username}'s user account";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "input"
        "wheel"
        "video"
        "audio"
        "tss"
      ];
    };
    gaming.username = username;
  };
  imports = [
    ./settings.nix
    ./uwsm.nix
    ./greeting
    ./hardware
    ./hyprland
    ./gaming
  ];
}

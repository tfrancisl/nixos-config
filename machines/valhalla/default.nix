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
    nix.settings = {
      accept-flake-config = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

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
    ./quickshell.nix
    ./greeting.nix
    ./system
    ./hyprland
    ./user
    ./gaming
  ];
}

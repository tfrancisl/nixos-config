{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
    xdg = {
      autostart.enable = lib.mkForce false;
      portal = {
        enable = true;
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
    i18n.defaultLocale = "en_US.UTF-8";
  };
}

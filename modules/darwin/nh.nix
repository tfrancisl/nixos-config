{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
  nh = lib.getExe pkgs.nh;
in {
  config = {
    # nh works on darwin via `nh darwin switch` but nix-darwin
    # doesn't have a programs.nh module, so install and configure manually
    hjem.users.${username}.packages = [pkgs.nh];
    environment.variables.NH_FLAKE = "/Users/${username}/nixos-config";

    # Equivalent of programs.nh.clean on NixOS — same command, launchd instead of systemd
    launchd.daemons.nh-clean = {
      command = "${nh} clean all --keep-since 10d --keep 4 --optimise";
      serviceConfig = {
        StartCalendarInterval = [
          {
            Weekday = 0;
            Hour = 3;
            Minute = 15;
          }
        ];
        StandardOutPath = "/var/log/nh-clean.log";
        StandardErrorPath = "/var/log/nh-clean.log";
      };
    };
  };
}

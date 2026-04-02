{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  inherit (config.acme.core) username;
  myNixFmt = pkgs.callPackage "${self}/packages/fmt.nix" {};
in {
  options.acme = {
    core.username = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    users.users.${username} = {
      description = "${username}'s user account";
      shell = pkgs.fish;
      packages = [myNixFmt pkgs.nixd];
    };

    environment.variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    programs.fish = {
      enable = true;
    };
    time.timeZone = "America/New_York"; # EST/EDT
  };
}

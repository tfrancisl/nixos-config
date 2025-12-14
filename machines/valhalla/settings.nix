{config, ...}: let
  username = config.system_user.username;
in {
  time.timeZone = "America/New_York"; # EST/EDT
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    fallback = true;
    connect-timeout = 10;

    # Can add more settings to nixConfig in flake
    trusted-users = [username];
  };
}

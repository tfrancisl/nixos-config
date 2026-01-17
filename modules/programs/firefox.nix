{
  pkgs,
  config,
  lib,
  ...
}: {
  options.acme = {
    firefox.enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf config.acme.firefox.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs."firefox-bin";
      };
    };
  };
}

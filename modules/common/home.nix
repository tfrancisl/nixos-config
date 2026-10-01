{
  lib,
  config,
  pkgs,
  pkgs',
  hjemImpureModule,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  options.acme = {
    core.username = lib.mkOption {
      type = lib.types.str;
    };
    hjemImpureSource = lib.mkOption {
      description = "Maps a path in this repo to a hjem source that hjem-impure can relink.";
      readOnly = true;
      type = lib.types.functionTo lib.types.str;
      default =
        path:
        config.hjem.users.${username}.impure.dotsDir + lib.removePrefix (toString ./../..) (toString path);
    };
  };
  config = {
    hjem = {
      cli.package = pkgs'.hjemCli;
      linker = pkgs.smfh;
      clobberByDefault = true;
      users.${username} = {
        enable = true;
        impure = {
          enable = true;

          dotsDir = "${./../..}";
          dotsDirImpure = "${config.environment.variables.NH_FILE}";
        };
      };
      extraModules = [ hjemImpureModule ];
    };
    programs.fish.enable = true;
    time.timeZone = "America/New_York"; # EST/EDT
  };
}

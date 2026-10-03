{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.acme.core) username;
  inherit (config.acme) hjemImpureSource;

  autoloadScripts = lib.filter (lib.hasSuffix ".nu") (lib.attrNames (builtins.readDir ./autoload));
in
{
  hjem.users.${username} = {
    packages = [
      pkgs.nushell
    ];
    xdg.config.files = lib.genAttrs' autoloadScripts (
      name:
      lib.nameValuePair "nushell/autoload/${name}" {
        source = hjemImpureSource ./autoload/${name};
      }
    );
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
    acme.zed.zed-bin = lib.getExe pkgs.zed-editor;
    hjem.users.${username} = {
      packages = [
        pkgs.zed-editor
        pkgs.package-version-server
      ];
    };
  };
}

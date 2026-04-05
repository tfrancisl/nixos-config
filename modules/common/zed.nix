{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.acme.core) username;
  zed-bin = lib.getExe pkgs.zed-editor;
in {
  config = {
    hjem.users.${username} = {
      packages = [
        pkgs.zed-editor
        pkgs.package-version-server
      ];
      xdg.config.files = {
        "zed/settings.json".source = ./zed-settings.json;
      };
    };
    environment.shellAliases = {
      "zed" = zed-bin;
    };
    environment.variables = {
      "EDITOR" = zed-bin;
      "VISUAL" = zed-bin;
    };
  };
}

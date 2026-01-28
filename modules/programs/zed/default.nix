{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    zed-editor.enable = lib.mkEnableOption "zed-editor";
  };
  config = lib.mkIf config.acme.zed-editor.enable {
    hjem.users.${username} = {
      packages = [
        pkgs.zed-editor
      ];
      xdg.config.files = {
        "zed/settings.json".source = ./settings.json;
      };
    };
    environment.shellAliases = {
      "zed" = "${pkgs.zed-editor}/bin/zeditor";
    };
  };
}

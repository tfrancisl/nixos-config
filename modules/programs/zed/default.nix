{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
  zed-bin = "${pkgs.zed-editor}/bin/zeditor";
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
      "zed" = zed-bin;
    };
    environment.sessionVariables = {
      "EDITOR" = zed-bin;
      "VISUAL" = zed-bin;
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.acme.zed-editor;
  inherit (config.acme.core) username;
  zed-bin = "${pkgs.zed-editor}/bin/zeditor";
in {
  options.acme = {
    zed-editor.enable = lib.mkEnableOption "zed-editor";
  };
  config = lib.mkIf cfg.enable {
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

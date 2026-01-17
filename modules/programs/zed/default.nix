{
  config,
  pkgs-stable,
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
        pkgs-stable.zed-editor-fhs
      ];
      files = {
        ".config/zed/settings.json".source = ./settings.json;
      };
    };
    environment.shellAliases = {
      "zed" = "${pkgs-stable.zed-editor-fhs}/bin/zeditor";
    };
  };
}

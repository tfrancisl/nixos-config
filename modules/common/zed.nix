{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.acme.zed-editor;
  inherit (config.acme.core) username;
  zed-bin = "${cfg.package}/bin/zeditor";
in {
  options.acme = {
    zed-editor = {
      package = lib.mkOption {
        description = "Zed editor package.";
        default = pkgs.zed-editor;
        type = lib.types.package;
      };
    };
  };

  config = {
    hjem.users.${username} = {
      packages = [
        pkgs.zed-editor
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

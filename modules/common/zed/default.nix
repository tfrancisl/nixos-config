{
  lib,
  config,
  ...
}:
let
  inherit (config.acme.core) username;
  inherit (config.acme.zed) zed-bin;
  inherit (config.acme) hjemImpureSource;
in
{
  options.acme.zed = {
    zed-bin = lib.mkOption {
      description = "The store path for the zed binary. Used to handle nixpkgs vs brew zed.";
    };
  };

  config = {
    hjem.users.${username} = {
      xdg.config.files = {
        "zed/settings.json".source = hjemImpureSource ./settings.json;
      };
      files = {
        ".config/fish/conf.d/aliases.fish".text = ''
          alias zed '${zed-bin}'
        '';
      };
    };
    environment.variables = {
      "EDITOR" = zed-bin;
      "VISUAL" = zed-bin;
    };
  };
}

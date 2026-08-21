{ config, ... }:
let
  inherit (config.acme.core) username;
in
{
  services.aerospace.enable = false; # managed with brew
  homebrew.casks = [ { name = "aerospace"; } ];
  hjem.users.${username}.files.".config/aerospace/aerospace.toml".source = ./aerospace.toml;
}

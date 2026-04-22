{ config, ... }:
let
  inherit (config.acme.core) username;
in
{
  config = {
    nix.settings = {
      trusted-users = [ username ];
    };
  };
}

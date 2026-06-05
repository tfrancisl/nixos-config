{ config, ... }:
let
  inherit (config.acme.core) username;
in
{
  config = {
    nix.settings = {
      trusted-users = [ username ];
      ssl-cert-file = "/Users/tlester/macos-keychain.crt";
    };
  };
}

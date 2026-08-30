{ pkgs', ... }:
{
  services.ncro = {
    enable = true;
    package = pkgs'.ncroPkg;
    settings = {
      addUpstreamPublicKeys = true;
      upstreams =
        let
          manicSystemsPubkey = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
        in
        [
          {
            url = "https://cache.nixos.org";
            priority = 10;
            public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          }
          {
            url = "https://nix-community.cachix.org";
            priority = 20;
            public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          }
          {
            url = "https://claude-code.cachix.org";
            priority = 30;
            public_key = "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=";
          }
          {
            url = "https://ci.manic.systems/projects/ncro/nix-cache";
            priority = 30;
            public_key = manicSystemsPubkey;
          }
          {
            url = "https://ci.manic.systems/projects/hjem/nix-cache";
            priority = 30;
            public_key = manicSystemsPubkey;
          }
        ];
      logging.timestamps = false;
    };
  };
  nix.settings.substituters = [ "http://localhost:8080" ];
}

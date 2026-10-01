{
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  acme.brews = [
    "direnv"
    "mise"
    "usage"
  ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };
  hjem.users.${username} = {
    packages = [
      pkgs.mise
      pkgs.usage
    ];
  };
}

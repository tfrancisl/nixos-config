{
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
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
  };
}

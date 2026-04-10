{
  inputs,
  lib,
  config,
  system,
  ...
}: let
  cfg = config.acme.noctalia;
in {
  options.acme = {
    noctalia.enable = lib.mkEnableOption "noctalia shell";
  };
  config = lib.mkIf cfg.enable {
    services.noctalia-shell.enable = true;
    environment.systemPackages = [inputs.noctalia.packages.${system}.default];
  };
  imports = [
    inputs.noctalia.nixosModules.default
  ];
}

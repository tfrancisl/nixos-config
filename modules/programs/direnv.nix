{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    enableXonshIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };
  environment.systemPackages = [
    pkgs.mise
    pkgs.usage
  ];
}

_: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    enableXonshIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };
}

{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs."firefox-bin"; # official firefox dist
  };

  # maybe: Add other program configurations
  # programs.git = {
  #   enable = true;
  #   userName = "...";
  #   userEmail = "...";
  # };
  # programs.zed-editor = { ... };
}

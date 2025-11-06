{pkgs, ...}: {
  # Program-specific configurations
  # Portable across NixOS and nix-darwin

  programs.firefox = {
    enable = true;
    package = pkgs."firefox-bin"; # official firefox dist
    # Future: Add firefox preferences, extensions, policies
  };

  # Future: Add other program configurations
  # programs.git = {
  #   enable = true;
  #   userName = "...";
  #   userEmail = "...";
  # };
  # programs.zed-editor = { ... };
}

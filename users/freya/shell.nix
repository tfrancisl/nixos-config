{pkgs, ...}: {
  # Fish shell configuration
  # Portable across NixOS and nix-darwin
  programs.fish = {
    enable = true;
    # Future: Add fish configuration here
    # - aliases
    # - functions
    # - shell init scripts
    # - plugins
  };
}

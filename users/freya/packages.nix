{pkgs, ...}: {
  # Portable user packages - dev tools, editor, CLI utilities
  # Can be reused across NixOS machines or with nix-darwin on macOS
  users.users.freya.packages = with pkgs; [
    # Terminal and CLI utilities
    alacritty # terminal emulator
    nnn # file manager
    htop # process monitor

    # Version control and development tools
    git
    gh # GitHub CLI
    jq # JSON processor

    # Editor and language support
    zed-editor
    alejandra # Nix formatter

    # Language servers (for editor integration)
    package-version-server # used by zed - zed ships dynamically linked version
    hyprls # Hyprland config LSP
    nixd # Nix LSP

    # Development utilities
    difftastic # diff tool
  ];
}

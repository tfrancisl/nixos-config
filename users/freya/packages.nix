{pkgs, ...}: {
  users.users.freya.packages = with pkgs; [
    wofi

    alacritty
    nnn
    htop

    git
    gh
    jq

    difftastic

    zed-editor
    alejandra

    package-version-server # used by zed - zed ships dynamically linked version
    hyprls
    nixd

    discord
    spotify
    r2modman
  ];

  programs.firefox = {
    enable = true;
    package = pkgs."firefox-bin"; # official firefox dist
  };

  environment.shellAliases = {
    "zed" = "${pkgs.zed-editor}/bin/zeditor";
  };

  programs.fish = {
    enable = true;
  };

  # maybe: Add other program configurations
  # programs.git = {
  #   enable = true;
  #   userName = "...";
  #   userEmail = "...";
  # };
  # programs.zed-editor = { ... };
}

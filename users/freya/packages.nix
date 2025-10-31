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
}

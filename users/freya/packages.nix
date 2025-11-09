{pkgs, ...}: {
  users.users.freya.packages = with pkgs; [
    wofi

    discord
    spotify
    r2modman
  ];
}

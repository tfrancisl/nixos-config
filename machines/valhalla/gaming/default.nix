{
  pkgs,
  username,
  ...
}: {
  users.users.${username} = {
    extraGroups = [
      "gamemode"
    ];
    packages = with pkgs; [
      lunar-client
      wofi
      discord
      spotify
      r2modman
    ];
  };

  imports = [
    ./steam.nix
  ];
}

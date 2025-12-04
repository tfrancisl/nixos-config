{
  pkgs,
  username,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}'s user account";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
  };

  imports = [
    ./greeting.nix
    ./system.nix
  ];
}

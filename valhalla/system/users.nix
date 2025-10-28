{pkgs, ...}: {
  users.users.freya = {
    isNormalUser = true;
    description = "freya";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
      "gamemode"
    ];
  };
}

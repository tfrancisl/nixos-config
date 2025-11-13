{pkgs, ...}: {
  # User account creation (machine-specific)
  # User packages and program configs are in ../../users/freya/
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
    packages = with pkgs; [
      lunar-client
    ];
  };
}

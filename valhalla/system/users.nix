{ pkgs, ... }:
{

  users.users.freya =

    {
      isNormalUser = true;
      description = "freya";
      initialPassword = "vm_changeme"; # Set default for vm
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

}

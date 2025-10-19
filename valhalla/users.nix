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

      packages = with pkgs; [
        alacritty

        wofi
        dunst
        nnn
        htop

        discord
        spotify

        r2modman # unity mods, mostly ror2

        git
        gh
        jq

        zed-editor
        # LSPs
        hyprls
        package-version-server # used by zed - zed ships a dynamically linked version
        nixd
        nixfmt-rfc-style

        difftastic

      ];
    };

}

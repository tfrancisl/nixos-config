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
        fish

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

  # Greeting + start hyprland under UWSM
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F'";
        user = "greeter";
      };
    };
  };

  users.users.greeter = {
    isNormalUser = false;
    description = "greetd greeter user";
    extraGroups = [
      "video"
      "audio"
    ];
    linger = true;
  };
}

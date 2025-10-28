{pkgs, ...}: {
  programs = {
    fish.enable = true;
    firefox = {
      enable = true;
      package = pkgs."firefox-bin"; # official firefox dist
    };
  };

  users.users.freya = {
    packages = with pkgs; [
      alacritty

      wofi
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
      package-version-server # used by zed - zed ships a dynamically linked version
      hyprls
      nixd
      alejandra

      difftastic
    ];
  };
}

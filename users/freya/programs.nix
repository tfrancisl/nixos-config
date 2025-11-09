{pkgs, ...}: {
  # User packages
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

  # Program configurations
  programs = {
    # Git configuration
    git = {
      enable = true;
      config = {
        core = {
          editor = "$EDITOR --wait";
        };
        difftool.zed = {
          cmd = "$EDITOR --wait --diff \"$LOCAL\" \"$REMOTE\"";
        };
        diff = {
          tool = "zed";
        };
        push = {
          autoSetupRemote = true;
        };
        pull = {
          ff = true;
        };
        alias = {
          st = "status";
          dis = "difftool -y --staged";
          oops = "reset HEAD~1";
          new = "switch -c";
          # https://git-scm.com/docs/pretty-formats/2.35.0
          logp = "log  --pretty=format:'%C(green)%ad%Creset %<(11,trunc)(%cr) %C(yellow)%h%Creset %<(50,mtrunc)%s %C(blue)[%an]%Creset' --date='format-local:%d%b%Y %H:%M'";
        };
        fetch = {
          all = true;
          prune = true;
          pruneTags = true;
        };
        rerere = {
          enabled = true;
        };
        init = {
          defaultBranch = "main";
        };
        advice = {
          skippedCherryPicks = false;
        };
      };
    };

    # Firefox configuration
    firefox = {
      enable = true;
      package = pkgs."firefox-bin"; # official firefox dist
    };

    # Fish shell configuration
    fish = {
      enable = true;
    };
  };

  # Shell aliases
  environment.shellAliases = {
    "zed" = "${pkgs.zed-editor}/bin/zeditor";
  };

  # Zed editor configuration
  # Since we're not using home-manager, we'll create the config file via activation script
  system.activationScripts.zedConfig = {
    text = ''
      mkdir -p /home/freya/.config/zed
      cat > /home/freya/.config/zed/settings.json << 'EOF'
      ${builtins.readFile ./zed/settings.json}
      EOF
      chown -R freya:users /home/freya/.config/zed
      chmod 644 /home/freya/.config/zed/settings.json
    '';
  };
}

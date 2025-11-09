{
  pkgs,
  username,
  zedSettings ? null,
  ...
}: let
  update-zed-config = pkgs.writeShellScriptBin "update-zed-config" ''
    ${builtins.readFile ./zed/update-zed-config.sh}
  '';
in {
  users.users.${username}.packages =
    (with pkgs; [
      alacritty
      nnn
      htop

      git
      gh
      jq

      difftastic

      zed-editor
      alejandra

      package-version-server # zed ships dynamically linked, needs this
      hyprls
      nixd
    ])
    ++ [update-zed-config];

  programs = {
    git = {
      enable = true;
      config = {
        core = {
          editor = "zed --wait";
        };
        difftool.zed = {
          cmd = "zed --wait --diff \"$LOCAL\" \"$REMOTE\"";
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

    firefox = {
      enable = true;
      package = pkgs."firefox-bin";
    };

    fish = {
      enable = true;
    };
  };

  environment.shellAliases = {
    "zed" = "${pkgs.zed-editor}/bin/zeditor";
  };

  system.activationScripts.zedConfig = {
    text =
      if zedSettings != null
      then ''
        mkdir -p /home/${username}/.config/zed
        cat > /home/${username}/.config/zed/settings.json << 'EOF'
        ${builtins.readFile zedSettings}
        EOF
        chown -R ${username}:users /home/${username}/.config/zed
        chmod 644 /home/${username}/.config/zed/settings.json
      ''
      else "";
  };
}

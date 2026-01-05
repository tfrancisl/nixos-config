# TODO modularize a bit
# productivity vs gaming vs hardware etc
{pkgs, ...}: let
  username = "freya";
in {
  hjem.users.${username} = {
    packages = with pkgs; [
      alacritty
      nnn
      htop

      git
      gh
      jq
      ripgrep

      zed-editor-fhs
      alejandra
      nixd

      rivalcfg # CLI for SteelSeries mouse hardware config
      lxqt.qps # qt process monitor
    ];
    files = {
      ".config/zed/settings.json".source = ./zed/settings.json;
      ".gitconfig".source =
        (pkgs.formats.gitIni {}).generate "config"
        {
          user = {
            name = "Tim Lester";
            email = "tfrancislester@gmail.com";
            username = "tfrancisl";
          };
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
  };

  programs = {
    git = {
      enable = true;
    };

    firefox = {
      enable = true;
      package = pkgs."firefox-bin";
    };

    fish = {
      enable = true;
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 10d --keep 4 --optimise";
      flake = "/home/${username}/nixos-config";
    };
  };

  environment.shellAliases = {
    "zed" = "${pkgs.zed-editor-fhs}/bin/zeditor";
  };
}

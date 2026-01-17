{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.acme.core) username;
in {
  options.acme = {
    git.enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.acme.git.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        (git.override {
          pythonSupport = false;
          perlSupport = false;
          rustSupport = true;
        })

        gh
        jq
        ripgrep
      ];
      files = {
        # TODO options for more of this (maybe the whole thing)
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
  };
}

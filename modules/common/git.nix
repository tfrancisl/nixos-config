{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.acme.git;
  inherit (config.acme.core) username;
  zed-bin = lib.getExe pkgs.zed-editor;
  gh-bin = lib.getExe pkgs.gh;
  fzfDiffTools =
    pkgs.callPackage
    "${self}/packages/fzf-diff-tools.nix"
    {};
in {
  options.acme = {
    git = {
      user = {
        name = lib.mkOption {type = lib.types.str;};
        email = lib.mkOption {type = lib.types.str;};
        username = lib.mkOption {type = lib.types.str;};
      };
    };
  };

  config = {
    hjem.users.${username} = {
      packages =
        [
          (pkgs.git.override {
            pythonSupport = false;
            perlSupport = false;
            rustSupport = true;
          })
          pkgs.forgejo-cli
          pkgs.git-credential-oauth
          pkgs.gh
        ]
        ++ fzfDiffTools.packages;
      files = {
        # TODO options for more of this (maybe the whole thing)
        ".gitconfig".source =
          (pkgs.formats.gitIni {}).generate "config"
          {
            user = {
              inherit (cfg.user) name;
              inherit (cfg.user) email;
              inherit (cfg.user) username;
            };
            credential = {
              "https://github.com" = {
                helper = [
                  "${gh-bin} auth git-credential"
                ];
              };
              "https://codeberg.org" = {
                helper = [
                  "cache --timeout 7200"
                  "oauth"
                ];
                oauthClientId = "a4792ccc-144e-407e-86c9-5e7d8d9c3269";
                oauthAuthURL = "/login/oauth/authorize";
                oauthTokenURL = "/login/oauth/access_token";
              };
            };
            core = {
              editor = "${zed-bin} --wait";
            };
            difftool.zed = {
              cmd = "${zed-bin} --wait --diff \"$LOCAL\" \"$REMOTE\"";
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
        ".config/git/ignore".text = ''
          .direnv/
          .venv/
          .venv
          .claude/
        '';
      };
    };
  };
}

{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.acme.git;
  inherit (config.acme.core) username;
  zedBinary = lib.getExe pkgs.zed-editor;
  ghBinary = lib.getExe pkgs.gh;
  fzfDiffTools =
    pkgs.callPackage
    "${self}/packages/fzf-diff-tools.nix"
    {};
in {
  options.acme = {
    git.enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    hjem.users.${username} = {
      packages = with pkgs;
        [
          (git.override {
            pythonSupport = false;
            perlSupport = false;
            rustSupport = true;
          })

          gh
          forgejo-cli
          git-credential-oauth

          jq
          ripgrep
        ]
        ++ fzfDiffTools.packages;
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
            credential = {
              "https://github.com" = {
                helper = [
                  "${ghBinary} auth git-credential"
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
              editor = "${zedBinary} --wait";
            };
            difftool.zed = {
              cmd = "${zedBinary} --wait --diff \"$LOCAL\" \"$REMOTE\"";
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

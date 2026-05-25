{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
  inherit (lib) getExe;
in
{
  config = {
    hjem.users.${username} = {
      files = {
        ".config/fish/conf.d/aliases.fish".text = ''
          alias ls '${getExe pkgs.eza} --group-directories-first'
          alias l '${getExe pkgs.eza} -l --group-directories-first'
          alias la '${getExe pkgs.eza} -la --group-directories-first'
          alias tree '${getExe pkgs.eza} --tree --group-directories-first'

          alias cat '${getExe pkgs.bat} --plain'
        '';
        ".config/fish/conf.d/abbreviations.fish".text = ''
          # nix shortcuts — expand on space so you see the full command
          abbr --add ns 'nix shell nixpkgs#'
          abbr --add nr 'nix run nixpkgs#'
        '';
      };
    };
  };
}

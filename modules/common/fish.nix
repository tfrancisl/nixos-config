{
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
  getExe = config.acme.exe;
in
{
  acme.brews = [
    "fish"
    "eza"
    "bat"
  ];
  hjem.users.${username} = {
    files =
      let
        lsArgs = "--group-directories-first";
        todayStr = "%Y%m%d";
        thisSecondStr = "%H%M%S";
        dateStr = todayStr + thisSecondStr;
      in
      {
        ".config/fish/conf.d/aliases.fish".text = ''
          alias ls '${getExe pkgs.eza} ${lsArgs}'
          alias l '${getExe pkgs.eza} -l ${lsArgs}'
          alias la '${getExe pkgs.eza} -la ${lsArgs}'
          alias tree '${getExe pkgs.eza} --tree ${lsArgs}'

          alias cat '${getExe pkgs.bat} --plain'

          alias today 'date +${todayStr}'
          alias todayu 'date -u +${todayStr}'
          alias rn 'date +${dateStr}'
          alias rnu 'date -u +${dateStr}'
        '';
        # probably worth excluding on darwin export
        ".config/fish/conf.d/abbreviations.fish".text = ''
          # nix shortcuts — expand on space so you see the full command
          abbr --add ns 'nix shell nixpkgs#'
          abbr --add nr 'nix run nixpkgs#'
        '';
      };
  };
}

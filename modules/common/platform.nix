{ lib, ... }:
{
  options.acme = {
    exe = lib.mkOption {
      description = "Maps a package to the command used to invoke it in generated config files.";
      type = lib.types.functionTo lib.types.str;
      default = lib.getExe;
    };
    brews = lib.mkOption {
      description = "Homebrew formulae for the exported darwin dotfiles. Ignored on NixOS.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
}

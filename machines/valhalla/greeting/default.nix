{lib, ...}: {
  options.greeting.mode = lib.mkOption {type = lib.types.enum ["instalogin" "tuigreet" "basic"];};
  imports = [./instalogin.nix ./tuigreet.nix];
}

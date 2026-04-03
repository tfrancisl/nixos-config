{lib, ...}: {
  inherit (import ./tree.nix {inherit lib;}) listNixFilesRecursive;
}

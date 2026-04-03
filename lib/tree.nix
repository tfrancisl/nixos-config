{lib, ...}: {
  listNixFilesRecursive = module:
    lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive module);
}

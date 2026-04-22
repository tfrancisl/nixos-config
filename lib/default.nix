{ lib, ... }:
{
  inherit (import ./tree.nix { inherit lib; }) listNixFilesRecursive;
  inherit (import ./hyprland.nix { inherit lib; }) toHyprlang flattenAttrs;
}

let
  inputs = import ./.tack;
in
{
  inherit (inputs)
    nixpkgs
    hjem
    claude
    ncro
    nix-darwin
    ;
}

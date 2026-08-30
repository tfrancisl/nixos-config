let
  inputs = import ./.tack;
  inherit (inputs)
    nixpkgs
    hjem
    claude
    ncro
    nix-darwin
    ;

in
{
  inherit
    nixpkgs
    hjem
    claude
    ncro
    nix-darwin
    ;
}

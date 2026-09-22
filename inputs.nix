let
  inputs = import ./.tack;
in
{
  inherit (inputs)
    nixpkgs
    hjem
    hjem-impure
    claude
    ncro
    nix-darwin
    ;
}

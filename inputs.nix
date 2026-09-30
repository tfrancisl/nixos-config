let
  inputs = import ./.tack;
in
{
  inherit (inputs)
    nixpkgs
    hjem
    hjem-impure
    ncro
    ;
}

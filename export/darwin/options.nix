# The work MacBook. Successor to machines/mymac/options.nix from the nix-darwin days.
{ lib, ... }:
let
  username = "tlester";
in
{
  acme = {
    core = { inherit username; };
    git.user = {
      name = "Tim Lester";
      email = "tflester@tflester.com";
      inherit username;
    };
    # Unverified guess at where the .dmg install lives.
    zed.zed-bin = "$HOME/Applications/Zed.app/Contents/MacOS/cli";
    # brew puts everything on PATH, so generated files refer to commands by name.
    exe = p: p.meta.mainProgram or (lib.getName p);
  };
  hjem.users.${username} = {
    directory = "/Users/${username}";
    files.".local/bin/acme-dots".source = ./acme-dots;
  };
}

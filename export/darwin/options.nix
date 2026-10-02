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
    zed.zed-bin = "/Applications/Zed.app/Contents/MacOS/cli";
    # brew puts everything on PATH, so generated files refer to commands by name.
    exe = p: p.meta.mainProgram or (lib.getName p);
  };
  hjem.users.${username} = {
    directory = "/Users/${username}";
    files.".local/bin/acme-dots".source = ./acme-dots;
  };
}

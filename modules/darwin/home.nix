{
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  hjem.users.${username} = {
    clobberFiles = true; # Required, or else updates prevent hjem from rewriting files it owns.
    directory = "/Users/${username}";
  };
  users.users.${username} = {
    description = "${username}'s user account";
    shell = pkgs.fish;
  };
}

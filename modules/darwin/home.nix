{
  config,
  pkgs,
  ...
}:
let
  inherit (config.acme.core) username;
in
{
  config = {
    hjem.users.${username} = {
      clobberFiles = false; # a bit risky on an existing macos install
      directory = "/Users/${username}";
    };
    users.users.${username} = {
      description = "${username}'s user account";
      shell = pkgs.fish;
    };
  };
}

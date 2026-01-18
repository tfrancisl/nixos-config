{...}: {
  acme = {
    core = {
      username = "hel";
    };
    greeter = {
      enable = true;
      autologin_command = "fish";
    };
    git.enable = true;
  };
}

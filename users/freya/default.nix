{pkgs, ...}: {
  imports = [
    (import ../common {
      inherit pkgs;
      username = "freya";
      zedSettings = ../common/zed/settings.json;
    })
    ./packages.nix
  ];

  # programs.git.config.user = {
  #   name = "Your Name";
  #   email = "your@email.com";
  # };
}

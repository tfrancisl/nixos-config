{pkgs, ...}: {
  imports = [
    (import ../common {
      inherit pkgs;
      username = "freya";
      zedSettings = ../common/zed/settings.json;
    })
    ./packages.nix
  ];
}

{pkgs, ...}: {
  # Machine-specific packages for valhalla
  # Portable user packages are in ../../users/freya/
  users.users.freya = {
    packages = with pkgs; [
      # Wayland/Hyprland utilities
      wofi # application launcher

      # Entertainment (machine-specific)
      discord
      spotify
      r2modman # unity mods, mostly ror2
    ];
  };
}

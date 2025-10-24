# nixos-config

My personal nix/NixOS configuration files. Currently targets one system, my gaming PC.


### Overview

#### nix features used
- flakes for lockfile
- flake-parts for modular flakes

#### Components
- [Hardware](./valhalla/hardware/)
  - [NVIDIA graphics](./valhalla/hardware/nvidia.nix)
  - [Kernel modules, disk mounts](./valhalla/hardware/hardware.nix)
- [Core system software](./valhalla/system/)
  - [Audio](./valhalla/system/audio.nix)
  - [TUI greeter, launches Hyprland UWSM session](./valhalla/system/greeting.nix)
  - [Catchall for other software](./valhalla/system/programs.nix)
  - [Bootloader and networking](./valhalla/system/system.nix)
  - [Regular users](./valhalla/system/users.nix) - likely to be refactored into home (mostly)
- [Hyprland](./valhalla/hyprland/)
  - [Keybinds](./valhalla/hyprland/binds.nix)
  - [Window and workspace rules](./valhalla/hyprland/rules.nix)
  - [Catchall settings](./valhalla/hyprland/settings.nix)
  - [Theme and appearance](./valhalla/hyprland/theme.nix)
- [User-specific settings](./valhalla/home/)
- [General settings](./valhalla/settings.nix)
  - Explicitly tracks unfree/non-free software.
  - Sets nix command line settings.
  - Sets nix store garbage collection.

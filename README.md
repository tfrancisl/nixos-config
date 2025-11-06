# nixos-config

My personal nix/NixOS configuration files. Currently targets one system, my gaming PC.


### Overview

#### nix features used
- flakes for lockfile
- flake-parts for modular flakes

#### Architecture

Configuration is split between portable user config and machine-specific settings:

- **Portable user config** ([`users/freya/`](./users/freya/)) - Development tools, editor, shell configuration. Can be reused across machines or adapted for nix-darwin.
- **Machine-specific config** ([`machines/valhalla/`](./machines/valhalla/)) - Hardware settings, Hyprland WM, system services, machine-specific packages.

#### Components

##### Portable User Configuration
- [User packages and tools](./users/freya/)
  - [Development tools, CLI utilities](./users/freya/packages.nix)
  - [Shell configuration](./users/freya/shell.nix)
  - [Program settings](./users/freya/programs.nix)

##### Machine-Specific Configuration (valhalla)
- [Hardware](./machines/valhalla/hardware/)
  - [NVIDIA graphics](./machines/valhalla/hardware/nvidia.nix)
  - [Kernel modules, disk mounts](./machines/valhalla/hardware/hardware.nix)
- [Core system software](./machines/valhalla/system/)
  - [Audio](./machines/valhalla/system/audio.nix)
  - [TUI greeter, launches Hyprland UWSM session](./machines/valhalla/system/greeting.nix)
  - [Catchall for other software](./machines/valhalla/system/programs.nix)
  - [Bootloader and networking](./machines/valhalla/system/system.nix)
  - [Regular users](./machines/valhalla/system/users.nix)
- [Hyprland](./machines/valhalla/hyprland/)
  - [Keybinds](./machines/valhalla/hyprland/binds.nix)
  - [Window and workspace rules](./machines/valhalla/hyprland/rules.nix)
  - [Catchall settings](./machines/valhalla/hyprland/settings.nix)
  - [Theme and appearance](./machines/valhalla/hyprland/theme.nix)
- [User-specific settings](./machines/valhalla/home/)
- [General settings](./machines/valhalla/settings.nix)
  - Explicitly tracks unfree/non-free software.
  - Sets nix command line settings.
  - Sets nix store garbage collection.

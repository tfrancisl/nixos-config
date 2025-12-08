# nixos-config

My personal nix/NixOS configuration files. Currently targets one system, my gaming PC.

### Overview

#### Layout

##### Portable User Configuration
- [User packages and tools](./users/)
  - [Common config (dev/coding tools, zed editor, general git config)](./users/common/)
  - [Valhalla user freya](./users/freya/)
  - TODO: MacOS/nix-darwin user.

##### Machine-Specific Configuration (valhalla)
- [Gaming (videogame and entertainment software, steam, gamemode)](./machines/valhalla/gaming/)
- [Greeters](./machines/valhalla/greeting/)
- [Hardware (mostly NixOS generated)](./machines/valhalla/hardware/)
- [Hyprland](./machines/valhalla/hyprland/)
- Root of valhalla config defines system user and general nix configuration.

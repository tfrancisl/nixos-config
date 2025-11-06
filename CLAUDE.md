# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal NixOS config for machine "valhalla". Uses flakes with flake-parts. Hyprland WM with NVIDIA GPU support. **Does NOT use home-manager** - user config is standard NixOS modules.

## Automated Workflow

**Hooks handle commits automatically** - you don't need to manually commit or format:

1. **SessionStart**: Ensures work happens on feature branch (not main)
2. **After each response**:
   - Auto-formats modified .nix files with alejandra
   - Runs `nix flake check` if .nix files changed (BLOCKING - commit prevented if fails)
   - Auto-commits changes with descriptive message (<80 chars) only if check passes

**Manual commands** (if needed):

```bash
# Rebuild system (most common)
sudo nixos-rebuild switch --flake .#valhalla

# Test without bootloader changes
sudo nixos-rebuild test --flake .#valhalla

# Update all flake inputs
nix flake update

# Manually check flake validity
nix flake check
```

## Module Structure

**Critical**: Don't modify `flake.nix` unless adding new inputs or machines. Configuration is split between portable user config and machine-specific config.

### Portable User Configuration

Location: `users/freya/` - Can be reused across machines or with nix-darwin

**Where to add portable user tooling**:
- Dev tools, editor, LSPs → `users/freya/packages.nix`
- Shell configuration → `users/freya/shell.nix`
- Program settings (git, firefox) → `users/freya/programs.nix`

### Machine-Specific Configuration

Location: `machines/valhalla/` - Specific to this NixOS machine

**Where to add machine-specific things**:
- Machine-specific packages → `machines/valhalla/home/default.nix`
- System programs → `machines/valhalla/system/programs.nix`
- Hyprland config → `machines/valhalla/hyprland/{binds,rules,settings,theme}.nix`
- Hardware changes → `machines/valhalla/hardware/`
- System services → `machines/valhalla/system/`


**Each directory has `default.nix` that imports submodules** - this pattern keeps configs modular.

## Adding Unfree Packages


Unfree software MUST be explicitly allowlisted in `machines/valhalla/settings.nix`:

```nix
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (pkgs.lib.getName pkg) [
    "package-name-here"  # Add to this list
  ];
```

Without allowlisting, builds fail with "unfree package" errors. Use `pkgs.lib.getName` to find correct name.

## Cachix Configuration

Hyprland cachix is configured in TWO places (both required):
- `flake.nix` nixConfig section (for `nix` commands)
- `machines/valhalla/settings.nix` nix.settings (for system daemon)

## Architecture

**Current structure separates portable user config from machine-specific config**:

- `users/freya/` - Portable user environment (dev tools, editor, shell)
  - Can be imported into other NixOS machines
  - Can be adapted for nix-darwin on macOS
  - Uses standard NixOS modules (NOT home-manager)

- `machines/valhalla/` - Machine-specific configuration
  - Hardware settings (GPU, boot, filesystems)
  - Hyprland window manager setup
  - Machine-specific packages (gaming, entertainment)
  - System services and networking

**Remaining limitations**:

1. **Single-machine hardcoding** - Username "freya" and hostname "valhalla" hardcoded throughout. No abstraction for multiple machines. The `users/freya/packages.nix` accepts a `username` parameter but this isn't utilized consistently yet.

## References

For Nix language syntax or advanced flake features:
- `man nix3-flake` - Flake command reference
- `man configuration.nix` - NixOS options
- https://nixos.org/manual/nix/stable/ - Nix manual
- https://wiki.nixos.org - Community wiki

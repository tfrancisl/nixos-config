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

**Critical**: Don't modify `flake.nix` unless adding new inputs or machines. Configuration lives in `valhalla/` subdirectories.

**Where to add things**:
- User packages → `valhalla/home/default.nix` (NixOS module, NOT home-manager)
- System programs → `valhalla/system/programs.nix`
- Hyprland config → `valhalla/hyprland/{binds,rules,settings,theme}.nix`
- Hardware changes → `valhalla/hardware/`
- System services → `valhalla/system/`

**Each directory has `default.nix` that imports submodules** - this pattern keeps configs modular.

## Adding Unfree Packages

Unfree software MUST be explicitly allowlisted in `valhalla/settings.nix`:

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
- `valhalla/settings.nix` nix.settings (for system daemon)

## Architecture Issues

**Current limitations** (affects reproducibility and cross-platform goals):

1. **Single-machine hardcoding** - Username "freya" and hostname "valhalla" hardcoded throughout. No abstraction for multiple machines.

2. **User vs system config not separated** - User tooling (zed, git, fish) mixed with system config. For cross-platform use (NixOS + macOS with mise/zed), you'll want portable user environment configs separate from machine-specific NixOS modules.

3. **User settings scattered** - User configuration split between `valhalla/home/` and `valhalla/system/users.nix` with no clear ownership boundaries.

**Better approach for cross-platform**: Extract user tooling configuration (editor, shell, dev tools) into shareable modules that can be consumed by both NixOS and nix-darwin/mise setups. Machine-specific config (Hyprland, hardware, system services) stays in valhalla/.

## References

For Nix language syntax or advanced flake features:
- `man nix3-flake` - Flake command reference
- `man configuration.nix` - NixOS options
- https://nixos.org/manual/nix/stable/ - Nix manual
- https://wiki.nixos.org - Community wiki

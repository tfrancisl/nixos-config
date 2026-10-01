exclude-nix-files := ('.tack/default.nix')

format:
    treefmt
lint:
    deadnix --exclude {{exclude-nix-files}} --fail .
    statix check -i {{exclude-nix-files}} .
# build the darwin dotfiles export (what CI releases) into ./result
export-darwin:
    nix build -f . packages.x86_64-linux.darwinDots

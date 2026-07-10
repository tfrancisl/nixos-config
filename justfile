exclude-nix-files := ('.tack/default.nix')

format:
    treefmt
lint:
    deadnix --exclude {{exclude-nix-files}} --fail .
    statix check -i {{exclude-nix-files}} .

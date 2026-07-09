exclude-nix-files := ('npins/default.nix')

format:
    treefmt
lint:
    deadnix --exclude {{exclude-nix-files}} --fail .
    statix check -i {{exclude-nix-files}} .

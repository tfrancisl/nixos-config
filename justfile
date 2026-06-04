system := `uname -m | sed 's/x86_64/x86_64-linux/; s/arm64/aarch64-darwin/'`
exclude-nix-files := ('npins/default.nix')

format:
    nix run -f default.nix formatter.{{system}}

lint:
    deadnix --exclude {{exclude-nix-files}} --fail .
    statix check -i {{exclude-nix-files}} .

{inputs, ...}: {
  imports = [
    ./user.nix
    ./brew.nix
    ./aerospace.nix
    ./sudo.nix
    inputs.hjem.darwinModules.default
  ];
}

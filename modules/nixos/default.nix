{inputs, ...}: {
  imports = [
    ./core
    ./programs
    inputs.hjem.nixosModules.default
  ];
}

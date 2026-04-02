{inputs, ...}: {
  imports = [
    ./gaming
    ./hyprland
    ./direnv.nix
    ./firefox.nix
    ./greeter.nix
    ./network.nix
    ./nh.nix
    ./nvidia.nix
    ./pipewire.nix
    ./sudo.nix
    ./system.nix
    ./user.nix
    inputs.hjem.nixosModules.default
  ];
}

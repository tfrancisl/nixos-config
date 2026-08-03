{ lib, ... }:
{
  security.sudo = lib.mkMerge [
    {
      enable = true;
      execWheelOnly = true;
    }
  ];
}

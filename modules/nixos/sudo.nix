{lib, ...}: {
  config = {
    security.sudo = lib.mkMerge [
      {
        enable = true;
        execWheelOnly = true;
      }
    ];
  };
}

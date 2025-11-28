{pkgs, ...}: {
  imports = [
    (import ../common {
      inherit pkgs;
      username = "freya";
    })
  ];
  # uv + python setup
  # https://nixos.org/manual/nixpkgs/unstable/#sec-uv
  users.users.freya.packages = with pkgs; [
    uv
    python314
  ];

  environment.sessionVariables.UV_PYTHON = "${pkgs.python314}/bin/python";
  environment.sessionVariables.UV_PYTHON_DOWNLOADS = "never";
}

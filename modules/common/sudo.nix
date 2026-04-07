{lib, ...}: {
  config = {
    security.sudo = lib.mkMerge [
      {
        extraConfig = ''
          Defaults lecture=never
          # show asterisks when entering password
          Defaults pwfeedback
          # keep some environment variables
          Defaults env_keep += "EDITOR PATH DISPLAY"
          # custom sudo prompt
          Defaults passprompt = "[*SUDO*]: "
          # If I entered my password within ten minutes, pls stop prompting me
          Defaults timestamp_timeout=10
        '';
      }
    ];
  };
}

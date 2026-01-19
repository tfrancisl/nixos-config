{...}: {
  config = {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture=never
        # show asterisks when entering password
        Defaults pwfeedback
        # keep some environment variables
        Defaults env_keep += "EDITOR PATH DISPLAY"
        # custom sudo prompt
        Defaults passprompt = "[*SUDO*]: "
      '';
    };
  };
}

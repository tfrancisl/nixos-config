{
  programs.hyprland.settings = {
    bind = [
      "$super_mod, C, killactive,"
      "$super_mod, M, exit,"
      "$super_mod, Q, exec, $terminal"
      "$super_mod, E, exec, $file_manager"
      "$super_mod, R, exec, $menu"
      "$super_mod, F, fullscreen"
      # super+shift+N to move to workspace
      "$super_mod SHIFT, 1, movetoworkspace, 1"
      "$super_mod SHIFT, 2, movetoworkspace, 2"
      # super+arrows to move focus
      "$super_mod, left, movefocus, l"
      "$super_mod, right, movefocus, r"
      "$super_mod, up, movefocus, u"
      "$super_mod, down, movefocus, d"
    ];

    bindm = [
      "$super_mod, mouse:272, movewindow"
      "$super_mod, mouse:273, resizewindow"
    ];
  };
}

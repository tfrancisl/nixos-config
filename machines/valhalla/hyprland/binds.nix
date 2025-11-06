{pkgs, ...}: let
  # Script to toggle active window between workspaces 1 and 2
  toggleWorkspaceScript = pkgs.writeShellScript "toggle-workspace" ''
    current_workspace=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '.workspace.id')

    if [ "$current_workspace" -eq 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 2
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace 1
    fi
  '';
in {
  programs.hyprland.settings = {
    bind = [
      "$super_mod, C, killactive,"
      "$super_mod, M, exit,"
      "$super_mod, Q, exec, $terminal"
      "$super_mod, E, exec, $file_manager"
      "$super_mod, R, exec, $menu"
      "$super_mod, F, fullscreen"
      "$super_mod, V, togglefloating,"
      "$super_mod, T, exec, ${toggleWorkspaceScript}"
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

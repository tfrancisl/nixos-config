hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop hyprland-session.target")
end)

hl.config({
    misc = {
        disable_hyprland_logo     = true,
        disable_splash_rendering  = true,
        middle_click_paste        = false,
        layers_hog_keyboard_focus = false,
        on_focus_under_fullscreen = false,
    },
    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

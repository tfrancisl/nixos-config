hl.config({
    general = {
        gaps_in      = 4,
        gaps_out     = 2,
        float_gaps   = 2,
        border_size  = 4,
        col = {
            active_border   = { colors = {"rgba(41d8d5ff)", "rgba(15f88dff)"}, angle = 45 },
            inactive_border = "rgba(680726ff)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },
    decoration = {
        rounding           = 5,
        active_opacity     = 1.0,
        fullscreen_opacity = 1.0,
        inactive_opacity   = 0.935,
        blur   = { enabled = false },
        shadow = { enabled = false },
    },
    animations = { enabled = true },
})

hl.curve("fastCurve", { type = "bezier", points = { {0.25, 0.65}, {0, 1.0} } })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 8,  bezier = "fastCurve" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 8,  bezier = "fastCurve" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 8,  bezier = "fastCurve" })
hl.animation({ leaf = "border",      enabled = true, speed = 8,  bezier = "fastCurve" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 80, bezier = "default", style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3,  bezier = "fastCurve" })

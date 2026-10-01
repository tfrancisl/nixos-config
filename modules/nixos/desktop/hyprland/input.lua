local programs = require("nix")
local mainMod  = "SUPER"

hl.config({
    input = {
        kb_layout              = "us",
        repeat_delay           = 300,
        repeat_rate            = 99,
        follow_mouse           = 1,
        off_window_axis_events = 2,
        sensitivity            = 0,
    },
})

hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(programs.launcher))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(programs.screenshot))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

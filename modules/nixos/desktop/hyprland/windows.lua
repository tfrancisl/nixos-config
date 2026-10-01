local terminalClass = "Alacritty"
local floatSize     = "0.5*(16/9)*monitor_h 0.5*monitor_h"
local floatMove     = "0.2*monitor_w 0.2*monitor_h"

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        enable_swallow          = 1,
        swallow_regex           = terminalClass,
        swallow_exception_regex = terminalClass,
    },
})

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name        = "solo-border",
    match       = { workspace = "w[tv1]", float = false },
    border_size = 4,
})

hl.window_rule({
    name              = "alacritty-float",
    match             = { class = "^(" .. terminalClass .. ")$" },
    float             = true,
    opacity           = "1.0 0.34",
    size              = floatSize,
    move              = floatMove,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name         = "float-inactive-border",
    match        = { float = true, focus = false },
    border_color = "rgb(111212)",
})

hl.window_rule({
    name         = "float-active-border",
    match        = { float = true, focus = true },
    border_color = "rgb(4122d5)",
})

hl.window_rule({
    name              = "float-size",
    match             = { float = true, class = "negate:[Ss]team" },
    size              = floatSize,
    move              = floatMove,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

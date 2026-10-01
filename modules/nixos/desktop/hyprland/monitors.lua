hl.monitor({
    output       = "desc:Microstep MAG 346CQ DD7M045200043",
    mode         = "3440x1440@180",
    position     = "1920x0",
    scale        = 1,
    bitdepth     = 10,
    supports_hdr = -1,
})

hl.monitor({
    output       = "desc:Acer Technologies ED270 X TKXAA0013W01",
    mode         = "1920x1080@60",
    position     = "0x0",
    scale        = 1,
    supports_hdr = -1,
})

hl.config({
    render = {
        direct_scanout = 0,
        cm_auto_hdr    = 0,
    },
    cursor = {
        default_monitor = "DP-3",
        zoom_factor     = 1,
        zoom_rigid      = false,
        hotspot_padding = 1,
    },
})

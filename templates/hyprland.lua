local terminal = "kitty"
local menu = "fuzzel -T " ..terminal.. " -b {{background}}dd"
local mainMod = "SUPER"

hl.config({
    general = {
        allow_tearing = false,
        border_size = 2,
        col = {
            active_border = "0x{{cursor}}ee",
            inactive_border = "0x{{black}}ee",
        },
        gaps_in = 5,
        gaps_out = 4,
        layout = "dwindle",
        resize_on_border = false,
    },
    decoration = {
        active_opacity = 1.0,
        blur = {
            enabled = true,
            passes = 1,
            size = 3,
            vibrancy = 0.1696,
        },
        inactive_opacity = 1.0,
        rounding = 10,
        rounding_power = 2,
        shadow = {
            color = "0x1a1a1aee",
            enabled = false,
            range = 4,
            render_power = 3,
        },
    },
    input = {
        follow_mouse = 1,
        kb_layout = "us",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        kb_variant = "",
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        font_family = "Fira",
        force_default_wallpaper = 1,
    },
    debug = {
        disable_logs = false,
    },
    cursor = {
        inactive_timeout = 1,
        no_hardware_cursors = true,
    },
    group = {
        groupbar = {
            col = {
            active = "0x{{blue}}ee",
            inactive = "0x{{black}}ee",

            },
            font_size = 11,
            text_color = "0xffffffff",
        },
    },
    dwindle = {
        preserve_split = true,
        smart_split = true,
    },
    animations = {
        enabled = true,
    },
    ecosystem = {
        no_donation_nag = true,
        no_update_news = true,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- windows
hl.bind(mainMod.."+ mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind(mainMod.."+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod.."+ V",hl.dsp.layout("togglesplit"))
hl.bind(mainMod.."+ SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod.."+ TAB", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod.."+ f", hl.dsp.window.fullscreen())
-- vim movement
for k,d in pairs({H = "left", L = "right", J = "down", K = "up",}) do
    hl.bind(mainMod.."+"..k, hl.dsp.focus({ direction = d }))
    hl.bind(mainMod.."+ SHIFT +"..k, hl.dsp.window.move({direction = d, group_aware = true}))
    hl.bind(mainMod.."+ CTRL +"..k, hl.dsp.workspace.move({ monitor = d }))
end

-- groups
hl.bind(mainMod.."+ T", hl.dsp.group.toggle())
hl.bind(mainMod.."+ I", hl.dsp.group.prev())
hl.bind(mainMod.."+ O", hl.dsp.group.next())

-- workspaces
for i = 1, 9 do
    hl.bind(mainMod.."+ " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod.."+ SHIFT + " .. i, hl.dsp.window.move({workspace = tostring(i)}))
end

-- toggle status bar
hl.bind(mainMod.."+ B",hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- screen
hl.bind(mainMod.."+ r",hl.dsp.exec_cmd("{{imbue}} wall random"))
hl.bind(mainMod.."+ 0", hl.dsp.exec_cmd("hyprlock --grace 0"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))
hl.bind("Print", hl.dsp.exec_cmd("slurp | grim -g - - | wl-copy"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("slurp | grim -g - - | swappy -f -"))
hl.bind(mainMod.."+ page_up", hl.dsp.exec_cmd("slurp | grim -g - - | swappy -f -"))

-- audio/media
hl.bind(mainMod.."+ P", hl.dsp.exec_cmd("mpc toggle"), {locked=true})
hl.bind(mainMod.."+ SHIFT + P", hl.dsp.exec_cmd("mpc prev"))
hl.bind(mainMod.."+ N", hl.dsp.exec_cmd("mpc next"))
hl.bind(mainMod.."+ SHIFT + N",hl.dsp.exec_cmd(
    "mpc insert $(mpc listall -f '%title% %artist%\t%file%' | "..menu.." -d -w 80 --with-nth=1 --accept-nth=2)"
))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- power
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("notify-send 'power button'"))

-- autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & mako & hypridle")
    hl.exec_cmd("hyprpaper & {{imbue}} wall random -i 1hr")
    hl.exec_cmd("nu -c '{{imbue}} watch'")
    hl.exec_cmd("mpc add / & mpc repeat on & mpc random on")
    hl.exec_cmd(terminal)
end)

-- app shortcuts
hl.bind(mainMod.."+ space",hl.dsp.exec_cmd(menu))
hl.bind(mainMod.."+ RETURN",hl.dsp.exec_cmd(terminal))

-- animation curves
hl.curve("easeOutQuint", {type = "bezier", points = { {0.23, 1.0}, {0.32, 1.0} }})
hl.curve("easeInOutCubic", {type = "bezier", points = { {0.65, 0.05}, {0.36, 1.0} }})
hl.curve("linear", {type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0} }})
hl.curve("almostLinear", {type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} }})
hl.curve("quick", {type = "bezier", points = { {0.15, 0.0}, {0.1, 1.0} }})
-- speed unit is 100ms
hl.animation({leaf = "global", enabled = true, speed = 3, bezier = "easeInOutCubic",})

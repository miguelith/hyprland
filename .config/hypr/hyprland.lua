------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local browser = "firefox"
local fileManager = "dolphin"
local menu = "wofi --show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- /home/miguelith/.local/bin/battery-notify &")
	hl.exec_cmd("uwsm app -- waybar &")
	hl.exec_cmd("uwsm app -- dunst &")
	hl.exec_cmd("uwsm app -- hyprpaper &")
	hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")
	-- polkit agent (needed for udiskie auth prompts on privileged actions)
	hl.exec_cmd("uwsm app -- systemctl --user start hyprpolkitagent &")
	-- removable media auto-mounting (USB drives, SD cards)
	hl.exec_cmd("uwsm app -- udiskie -a -t &")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Managed by uwsm: ~/.config/uwsm/env and env-hyprland

-----------------------
----- PERMISSIONS -----
-----------------------

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 1,

		col = {
			active_border = { colors = { "rgba(88C0D0FF)", "rgba(88C0D0FF)" }, angle = 0 },
			inactive_border = "rgba(4C566AFF)",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.94,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.25,
			ignore_opacity = false,
			special = true,
			popups = true,
			input_methods = true,
		},
	},

	animations = {
		enabled = true,
		bezier = {
			"easeOutQuint,0.23,1,0.32,1",
			"linear,0,0,1,1",
		},
		animation = {
			-- Keep animations enabled, but make transitions snappier on older hardware.
			"windows,1,2,linear,popin 60%",
			"windowsOut,1,2,linear,popin 60%",
			"border,1,1,linear",
			"fade,1,1,linear",
			"workspaces,1,2,linear,fade",
		},
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		repeat_rate = 40,
		repeat_delay = 300,
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			disable_while_typing = false,
			middle_button_emulation = false,
		},
	},
})

-- Per-device config

hl.device({
	name = "at-translated-set-2-keyboard",
	repeat_rate = 40,
	repeat_delay = 300,
})

hl.device({
	name = "synps/2-synaptics-touchpad",
	scroll_factor = 0.5,
	sensitivity = 0,
})

hl.device({
	name = "tpps/2-ibm-trackpoint",
	sensitivity = -0.8,
	scroll_factor = 0.1,
	natural_scroll = false,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("wlogout"))

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd output-up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd output-down"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd output-mute"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd input-mute"),
	{ locked = true, repeating = true }
)

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("/home/miguelith/.local/bin/osd brightness-down"), { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- Clipboard
-- cliphist already emits newest entries first; keep Wofi from re-sorting them
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd(
		"cliphist list | wofi --dmenu --sort-order=default --cache-file=/dev/null | cliphist decode | wl-copy"
	)
)

-- Color picker (copies hex color to clipboard)
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Emoji picker (wofi + wtype, types into focused window)
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("/home/miguelith/.local/bin/emoji-picker"))

-- Toggle waybar (true toggle, not reload)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("/home/miguelith/.local/bin/waybar-toggle"))

-- Night light toggle (hyprsunset)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("/home/miguelith/.local/bin/hyprsunset-toggle"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

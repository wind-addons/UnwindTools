local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

---@class AudioDeviceSwitcher
local defaults = {
	profile = {
		enabled = false,
		ui = {
			general = {
				width = 120,
				height = 30,
				buttonBackdrop = true,
				mouseover = false,
				showTooltip = true,
			},
			font = {
				name = F.Font.DefaultName,
				style = F.Font.DefaultStyle,
				height = 13,
			},
		},
		device1 = {
			enable = false,
			pattern = "",
			displayName = "",
		},
		device2 = {
			enable = false,
			pattern = "",
			displayName = "",
		},
		device3 = {
			enable = false,
			pattern = "",
			displayName = "",
		},
		device4 = {
			enable = false,
			pattern = "",
			displayName = "",
		},
		device5 = {
			enable = false,
			pattern = "",
			displayName = "",
		},
	},
}

E:Module("Audio Device Switcher"):SetDefaults(defaults)

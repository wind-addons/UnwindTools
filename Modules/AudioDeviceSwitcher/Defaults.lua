local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher: WindModule

M.defaultDeviceSetting = { enable = false, pattern = "", displayName = "" }

---@class AudioDeviceSwitcher
local defaults = {
	profile = {
		enabled = false,
		ui = {
			general = {
				width = 120,
				height = 30,
				transparent = true,
				mouseover = false,
				showTooltip = true,
				lock = false,
			},
			font = {
				name = F.Font.DefaultName,
				style = F.Font.DefaultStyle,
				height = 13,
			},
		},
		devices = { M.defaultDeviceSetting },
	},
}

E:Module("Audio Device Switcher"):SetDefaults(defaults)

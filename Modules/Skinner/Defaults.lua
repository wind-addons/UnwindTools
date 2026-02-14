local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local defaults = {
	global = { ---@class Engine.Database.Global.General
		skinner = "Auto", ---@type "ElvUI" | "NDui" | "WindTools" | "None" | "Auto"
	},
}

E.AddDefaults("general", defaults)

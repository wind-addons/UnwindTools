local ns = select(2, ...) ---@type Namespace
local E = ns[1] ---@class Engine
local F = ns[2]
local L = ns[3]

E.AddDefaults("mover", {
	global = { ---@class Engine.Database.Global.Mover
		states = {}, ---@type table<MoverSavedID, PointData>
	},
})

-- Logging
E.AddDefaults("general", {
	global = { ---@class Engine.Database.Global.General
		logLevel = "ERROR", ---@type LogLevel
	},
})

E:AddGeneralSettings({
	logLevel = {
		order = 11,
		type = "select",
		name = L["Log Level"],
		desc = L["Set the minimum log level to display."],
		values = { ---@type table<LogLevel, string>
			DEBUG = F.Color.String("DEBUG", "emerald-600", "emerald-300"),
			INFO = F.Color.String("INFO", "blue-600", "blue-300"),
			WARN = F.Color.String("WARN", "amber-600", "amber-300"),
			ERROR = F.Color.String("ERROR", "rose-600", "rose-300"),
		},
		sorting = { "ERROR", "WARN", "INFO", "DEBUG" },
		get = function()
			return E.db.global.general.logLevel
		end,
		set = function(_, value)
			E.db.global.general.logLevel = value
			F.Logger.SetMinimumLogLevel(value)
		end,
	},
}, { id = "global", name = L["Global"] })

--- Locale
E.AddDefaults("general", {
	global = { ---@class Engine.Database.Global.General
		locale = GetLocale(),
	},
})

E:AddGeneralSettings({
	locale = {
		order = 12,
		type = "select",
		name = L["Locale"],
		width = 2,
		desc = L["Set the locale for the addon."],
		values = {
			deDE = F.Color.String("deDE", "amber-500") .. " - Deutsch",
			enUS = F.Color.String("enUS", "amber-500") .. " - English",
			esES = F.Color.String("esES", "amber-500") .. " - Español (España)",
			esMX = F.Color.String("esMX", "amber-500") .. " - Español (Latinoamérica)",
			frFR = F.Color.String("frFR", "amber-500") .. " - Français",
			itIT = F.Color.String("itIT", "amber-500") .. " - Italiano",
			koKR = F.Color.String("koKR", "amber-500") .. " - 한국어",
			ptBR = F.Color.String("ptBR", "amber-500") .. " - Português (Brasil)",
			ruRU = F.Color.String("ruRU", "amber-500") .. " - Русский",
			zhCN = F.Color.String("zhCN", "amber-500") .. " - 简体中文",
			zhTW = F.Color.String("zhTW", "amber-500") .. " - 繁體中文",
		},
		get = function()
			return E.db.global.general.locale
		end,
		set = function(_, value)
			E.db.global.general.locale = value
			E:ShowDialog("SettingRefreshReload")
		end,
	},
}, { id = "global", name = L["Global"] })

-- LibDBIcon
E.AddDefaults("general", {
	global = { ---@class Engine.Database.Global.General
		minimapIcon = { hide = false },
	},
})

E:AddGeneralSettings({
	minimapIcon = {
		type = "toggle",
		name = L["Minimap Icon"],
		desc = L["Toggle the display of the minimap icon."],
		order = 13,
		get = function()
			return E.db.global.general.minimapIcon.hide == false
		end,
		set = function(_, value)
			E.db.global.general.minimapIcon.hide = not value
			if value then
				LibStub("LibDBIcon-1.0"):Show(E.name)
			else
				LibStub("LibDBIcon-1.0"):Hide(E.name)
			end
		end,
	},
}, { id = "global", name = L["Global"] }, { order = 1 })

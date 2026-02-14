local name, ns = ... ---@type string, Namespace
local E = ns[1] ---@class Engine
local F = ns[2]

local L = ns[3]

E.name = name
E.locale = F.Table.SafeGet(F, "SaveVariables", "global", "general", "locale") or GetLocale()
E.title = F.Color.StringInWindStyle(L["Unwind Tools"])
E.version = C_AddOns.GetAddOnMetadata(name, "Version")
E.isChinese = E.locale == "zhCN" or E.locale == "zhTW"
E.isAsian = E.isChinese or E.locale == "koKR"

function E:OnInitialize()
	E.isElvUILoaded = C_AddOns.IsAddOnLoaded("ElvUI")
	E.isWindToolsLoaded = C_AddOns.IsAddOnLoaded("ElvUI_WindTools")
	E.isNDuiLoaded = C_AddOns.IsAddOnLoaded("NDui")

	self:BuildDatabase()
	self:BuildSettings()

	F.Logger.SetMinimumLogLevel(E.db.global.general.logLevel)
	F.Mover.SetStatesDB(E.db.global.mover.states)

	for _, module in self:IterateModules() do
		---@cast module WindModule
		module.profile = self.db.profile and self.db.profile[module.__id]
		module.global = self.db.global and self.db.global[module.__id]

		local enabled = module.profile and module.profile.enabled
		module:SetEnabledState(enabled)
	end
end

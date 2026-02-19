local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Skinner") ---@class Skinner

function M:RefreshConfigurableSkins()
	local skins = { None = L["None"], Auto = L["Auto"] }
	local sorting = { "Auto", "None" }
	if E.isElvUILoaded then
		skins.ElvUI = "ElvUI"
		sorting[#sorting + 1] = "ElvUI"

		if E.isWindToolsLoaded then
			skins.WindTools = "ElvUI + WindTools"
			sorting[#sorting + 1] = "WindTools"
		end
	end

	if E.isNDuiLoaded then
		skins.NDui = "NDui"
		sorting[#sorting + 1] = "NDui"
	end

	self.ConfigurableSkins, self.ConfigurableSkinsSorting = skins, sorting
end

E:AddGeneralSettings({
	skinner = {
		type = "select",
		name = L["Skinner"],
		order = 20,
		desc = string.format(L["Choose the skinner that will skin the UIs created by %s."], E.title),
		values = function()
			return M.ConfigurableSkins
		end,
		sorting = function()
			return M.ConfigurableSkinsSorting
		end,
		get = function()
			return E.db.global.general.skinner
		end,
		set = function(_, value)
			E.db.global.general.skinner = value
			E:ShowDialog("SettingRefreshReload")
		end,
	},
}, { id = "global", name = L["Global"] })

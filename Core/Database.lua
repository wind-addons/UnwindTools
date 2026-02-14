local ns = select(2, ...) ---@type Namespace
local E = ns[1] ---@class Engine
local F = ns[2]

---Called when the current profile is changed.
function E:OnProfileChanged()
	F.Logger.Debug("Profile has been changed to", self.db:GetCurrentProfile())

	for _, module in self:IterateModules() do
		module.profile = self.db.profile and self.db.profile[module.moduleName]
		if module.OnProfileChanged then
			module:OnProfileChanged()
		end
	end

	F.Logger.Debug("All modules's OnProfileChanged called")
end

---@class Defaults
---@field profile? table<string, any>
---@field global? table<string, any>

---@class Engine.Database: Defaults
local defaults = {
	profile = { ---@class Engine.Database.Profile
		general = {}, ---@class Engine.Database.Profile.General
	},
	global = { ---@class Engine.Database.Global
		general = {}, ---@class Engine.Database.Global.General
		mover = {}, ---@class Engine.Database.Global.Mover
	},
}

---Adds default settings for a module to the addon's database.
---@param moduleID? string The name of the module
---@param moduleDefaults Defaults The default settings for the module
function E.AddDefaults(moduleID, moduleDefaults)
	assert(type(moduleDefaults) == "table", "moduleDefaults must be a table")

	if moduleDefaults.profile then
		F.Table.DeepExtend(defaults, {
			profile = moduleID and { [moduleID] = moduleDefaults.profile } or moduleDefaults.profile,
		})
	end

	if moduleDefaults.global then
		F.Table.DeepExtend(defaults, {
			global = moduleID and { [moduleID] = moduleDefaults.global } or moduleDefaults.global,
		})
	end

	E:Debug(function()
		F.Logger.Debug("Defauls Added. ModuleID: ", moduleID, GetKeysArray(moduleDefaults))
	end)
end

---Gets the default settings for a module.
---@param moduleID string The name of the module
---@return Defaults The default settings for the module
function E.GetDefaults(moduleID)
	assert(type(moduleID) == "string", "moduleID must be a string")

	local moduleDefaults = {}
	if defaults.profile and defaults.profile[moduleID] then
		moduleDefaults.profile = CopyTable(defaults.profile[moduleID])
	end

	if defaults.global and defaults.global[moduleID] then
		moduleDefaults.global = CopyTable(defaults.global[moduleID])
	end

	return moduleDefaults
end

function E:BuildDatabase()
	---@class Engine.Database: AceDBObject-3.0
	self.db = LibStub("AceDB-3.0"):New(E.name .. "DB", defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
end

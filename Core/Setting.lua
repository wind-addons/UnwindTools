local ns = select(2, ...) ---@type Namespace
local E = ns[1] ---@class Engine
local F = ns[2]
local L = ns[3]

local LSM = LibStub("LibSharedMedia-3.0")

---@cast E Engine
---@cast F Functions

---Open the setting panel from the addon compartment click
function UnwindTools_OnAddonCompartmentClick()
	LibStub("AceConfigDialog-3.0"):Open(E.name)
end

---@alias SettingCategory "general"|"system"|"social"
---@type table<SettingCategory, { order: number, name: string, gradientColorTemplates: ColorTemplate[] }>
local settingCategories = {
	general = { order = 0, name = L["General"], gradientColorTemplates = { "emerald-500", "emerald-300" } },
	system = { order = 1, name = L["System Settings"], gradientColorTemplates = { "amber-500", "amber-300" } },
	social = { order = 2, name = L["Social & Guild"], gradientColorTemplates = { "blue-500", "blue-300" } },
}

local settings = {
	type = "group",
	name = E.title,
	childGroups = "tab",
	args = {},
}

---The setting group that registered to Blizzard's Options
local blizOptions = {
	type = "group",
	name = E.title,
	childGroups = "tab",
	args = {
		open = {
			name = L["Open Settings"],
			type = "execute",
			func = function()
				UnwindTools_OnAddonCompartmentClick()
			end,
			order = 1,
		},
	},
}

for categoryKey, categoryData in pairs(settingCategories) do
	settings.args[categoryKey] = {
		type = "group",
		order = categoryData.order,
		childGroups = "tab",
		name = F.Color.String(categoryData.name, unpack(categoryData.gradientColorTemplates)),
		args = {},
	}
end

---Adds a new settings group to the addon's configuration panel.
---@param settingCategory SettingCategory The category key to add the settings toggle under
---@param moduleName string The unique name of the settings group
---@param moduleID string The unique ID of the settings group
---@param moduleTitle string The title of the settings group
---@param moduleSettings table The settings table to add
---@param options? table Additional options to merge into the settings group
function E:AddSettings(settingCategory, moduleName, moduleID, moduleTitle, moduleSettings, options)
	assert(settingCategories[settingCategory] ~= nil, "Category not found: " .. tostring(settingCategory))
	assert(type(moduleName) == "string", "Module name must be a string, got " .. type(moduleName))
	assert(type(moduleID) == "string", "Module ID must be a string, got " .. type(moduleID))
	assert(type(moduleTitle) == "string", "Module title must be a string, got " .. type(moduleTitle))
	assert(type(moduleSettings) == "table", "Settings must be a table or nil, got " .. type(moduleSettings))
	assert(type(moduleTitle) == "string", "Title must be a string, got " .. type(moduleTitle))

	local defaultSetting = {
		type = "group",
		name = moduleTitle,
		order = #settings.args[settingCategory].args + 1,
		childGroups = "tab",
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable or disable %s."]:format(F.Color.String(moduleTitle, "blue-500")),
				get = function(_)
					local module = E:Module(moduleName)
					return module and module.profile.enabled
				end,
				set = function(_, value)
					local module = E:Module(moduleName)
					if not module then
						return
					end

					if module.profile.enabled ~= nil then
						module.profile.enabled = value
					end

					if value then
						module:Enable()
					else
						module:Disable()
					end
				end,
			},
			resetSetting = {
				order = 2,
				type = "execute",
				name = L["Reset Settings"],
				desc = L["Reset all settings for %s to default values."]:format(
					F.Color.String(moduleTitle, "blue-500")
				),
				confirm = true,
				confirmText = L["Are you sure you want to reset all settings for %s to default values?"]:format(
					F.Color.String(moduleTitle, "blue-500")
				),
				func = function()
					local defaults = E.GetDefaults(moduleID)
					E.db.profile[moduleID] = defaults.profile
					E.db.global[moduleID] = defaults.global
					C_UI.Reload()
				end,
			},
		},
	}

	settings.args[settingCategory].args[moduleID] = F.Table.Extend(
		settings.args[settingCategory].args[moduleID] or defaultSetting,
		{ name = moduleTitle, args = moduleSettings },
		options or {}
	)
end

---Adds a new general settings group to the addon's configuration panel.
---@param generalSettings table The settings table to add
---@param subGroup? { id: string, name: string } The unique ID and name of the settings group, if nil it adds to the main general settings
---@param options? table Additional options to merge into the settings group
function E:AddGeneralSettings(generalSettings, subGroup, options)
	assert(type(generalSettings) == "table", "Settings must be a table or nil, got " .. type(generalSettings))
	assert(type(subGroup) == "table" or subGroup == nil, "Group info must be a table or nil, got " .. type(subGroup))

	local setting = settings.args.general
	if subGroup then
		assert(type(subGroup.id) == "string", "Group ID must be a string, got " .. type(subGroup.id))
		assert(type(subGroup.name) == "string", "Group name must be a string, got " .. type(subGroup.name))

		setting.args[subGroup.id] = F.Table.Extend(setting.args[subGroup.id] or {
			type = "group",
			inline = true,
			order = CountTable(setting.args) + 1,
			args = {},
		}, { name = subGroup.name })

		setting = setting.args[subGroup.id]
	end

	F.Table.Extend(setting, { args = generalSettings }, options or {})
end

function E:BuildSettings()
	settings.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	settings.args.profiles.order = 1000

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(self.name, settings)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(self.name .. "BlizOptions", blizOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(self.name .. "BlizOptions", self.title)

	local launcher = LibStub("LibDataBroker-1.1"):NewDataObject(self.name, {
		type = "launcher",
		text = self.title,
		label = self.title,
		icon = E.Texture.Logo,
		OnClick = UnwindTools_OnAddonCompartmentClick,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(self.title)
			tooltip:AddLine(L["Click to toggle config window."])
		end,
	})

	LibStub("LibDBIcon-1.0"):Register(self.name, launcher, self.db.global.general.minimapIcon)
end

---@class FontSettingOptions
---@filed callback function? A callback function to be called when any font setting is changed
---@field startOrder number? The starting order for the font settings, default is 1
---@field subOptions table? Additional sub-options to merged into each args.
---@field asGroup boolean? Whether to return the settings as a group, default is false
---@field groupOptions table? Additional options to include in the group if asGroup is true
---@field groupName string? The name of the group if asGroup is true, default is L["Font Settings"]

---Generates font settings from the given table.
---@param configTable FontOptions | fun():FontOptions The table containing the font settings
---@param options? FontSettingOptions Additional options for generating font settings
function E:GetFontSettings(configTable, options)
	assert(
		type(configTable) == "table" or type(configTable) == "function",
		"Config table must be a table or function, got " .. type(configTable)
	)
	local getConfigTable = type(configTable) == "function" and configTable or function()
		return configTable
	end

	local order = options and not options.asGroup and options.startOrder or 1
	local callback = options and options.callback

	local args = {}
	args.fontHeight = {
		order = order,
		type = "range",
		name = L["Font Size"],
		desc = L["Set the font size."],
		min = 8,
		max = 24,
		step = 1,
		get = function()
			return getConfigTable().height
		end,
		set = function(_, value)
			getConfigTable().height = value
			if callback then
				callback()
			end
		end,
	}

	args.fontName = {
		order = order + 1,
		type = "select",
		name = L["Font Name"],
		desc = L["Select the font to use."],
		width = 1.5,
		dialogControl = "LSM30_Font",
		values = LSM:HashTable("font"),
		get = function()
			return getConfigTable().name
		end,
		set = function(_, value)
			getConfigTable().name = value
			if callback then
				callback()
			end
		end,
	}

	args.fontStyle = {
		order = order + 2,
		type = "select",
		name = L["Font Style"],
		desc = L["Set the font style."],
		values = {
			["NONE"] = L["None"],
			["OUTLINE"] = "OUTLINE",
			["THICKOUTLINE"] = "THICKOUTLINE",
			["MONOCHROME"] = "MONOCHROME",
		},
		get = function()
			return getConfigTable().style
		end,

		set = function(_, value)
			getConfigTable().style = value
			if callback then
				callback()
			end
		end,
	}

	if options and options.subOptions then
		F.Table.Extend(
			args,
			{ fontName = options.subOptions, fontStyle = options.subOptions, fontHeight = options.subOptions }
		)
	end

	if options and options.asGroup then
		local group = {
			type = "group",
			name = options.groupName or L["Font Settings"],
			order = options.startOrder,
			args = args,
		}

		if options.groupOptions then
			F.Table.Extend(group, options.groupOptions)
		end

		return group
	else
		return args
	end
end

---Set the input as a string list
---@param args { name: string }
---@param getConfigTable fun(): string[]
function E:SetStringListSetting(args, getConfigTable)
	assert(type(args) == "table", "args must be a table")
	assert(type(getConfigTable) == "function", "getConfigTable must be a function")

	args.get = function()
		return table.concat(getConfigTable(), ", ")
	end

	args.set = function(_, value)
		local tbl = getConfigTable()
		table.wipe(tbl)
		for pattern in string.gmatch(value, "[^,]+") do
			pattern = string.trim(pattern)
			if pattern ~= "" then
				table.insert(tbl, pattern)
			end
		end
	end
end


---Creates a simple divider for the settings panel.
---@param order number The order of the divider in the settings panel
---@return table The settings table for the divider
function E:GetSimpleDivider(order)
	return {
		type = "description",
		name = "",
		order = order,
		width = "full",
	}
end
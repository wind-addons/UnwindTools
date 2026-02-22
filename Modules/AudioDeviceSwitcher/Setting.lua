local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher

---@return table<number, string>
local function GetAllOutputDevices()
	local devices = {}
	local count = Sound_GameSystem_GetNumOutputDrivers()

	for index = 1, count do
		local name = Sound_GameSystem_GetOutputDriverNameByIndex(index)
		if F.Validator.IsNonEmptyString(name) then
			devices[index] = name
		end
	end

	return devices
end

---@return string
local function GetPatternInputDescription()
	local lines = {
		L["Partial or full system device name used for matching."],
		" ",
		L["Available Output Devices"] .. ":",
	}

	local devices = GetAllOutputDevices()
	local entries = {}
	for driverIndex, deviceName in pairs(devices) do
		table.insert(entries, { index = driverIndex, name = deviceName })
	end

	table.sort(entries, function(a, b)
		return a.index < b.index
	end)

	if #entries == 0 then
		table.insert(lines, F.Color.String(L["No output devices detected."], "gray-500"))
		return table.concat(lines, "\n")
	end

	for _, entry in ipairs(entries) do
		table.insert(lines, string.format("[%d] %s", entry.index, entry.name))
	end

	return table.concat(lines, "\n")
end

local settings = {
	ui = {
		order = 1,
		type = "group",
		name = L["UI"],
		args = {
			general = {
				order = 1,
				type = "group",
				name = L["General"],
				inline = true,
				args = {
					width = {
						order = 1,
						type = "range",
						name = L["Width"],
						desc = L["Set the width of the switch button."],
						min = 80,
						max = 400,
						step = 1,
						get = function()
							return M.profile.ui.general.width
						end,
						set = function(_, value)
							M.profile.ui.general.width = value
							M:UpdateUI()
						end,
					},
					height = {
						order = 2,
						type = "range",
						name = L["Height"],
						desc = L["Set the height of the switch button."],
						min = 20,
						max = 80,
						step = 1,
						get = function()
							return M.profile.ui.general.height
						end,
						set = function(_, value)
							M.profile.ui.general.height = value
							M:UpdateUI()
						end,
					},
					buttonBackdrop = {
						order = 3,
						type = "toggle",
						name = L["Button Backdrop"],
						desc = L["Show or hide the button backdrop."],
						get = function()
							return M.profile.ui.general.buttonBackdrop
						end,
						set = function(_, value)
							M.profile.ui.general.buttonBackdrop = value
							M:UpdateUI()
						end,
					},
					mouseover = {
						order = 4,
						type = "toggle",
						name = L["Mouseover"],
						desc = L["Only show the button when mouseover."],
						get = function()
							return M.profile.ui.general.mouseover
						end,
						set = function(_, value)
							M.profile.ui.general.mouseover = value
							M:UpdateUI()
						end,
					},
					showTooltip = {
						order = 5,
						type = "toggle",
						name = L["Show Tooltip"],
						desc = L["Show tooltips when hovering over the switch button."],
						get = function()
							return M.profile.ui.general.showTooltip
						end,
						set = function(_, value)
							M.profile.ui.general.showTooltip = value
						end,
					},
				},
			},
		},
	},
	devices = {
		order = 2,
		type = "group",
		name = L["Devices"],
		args = {
			desc = {
				order = 0,
				type = "description",
				name = L["The button is hidden when fewer than 2 devices are configured and matched."],
			},
		},
	},
}

settings.ui.args.font = E:GetFontSettings(function()
	return M.profile.ui.font
end, {
	asGroup = true,
	startOrder = 2,
	groupName = L["Font Settings"],
	groupOptions = {
		inline = true,
	},
	callback = function()
		M:UpdateUI()
	end,
})

for index = 1, 5 do
	local key = "device" .. index
	settings.devices.args[key] = {
		order = index,
		type = "group",
		name = string.format("%s %d", L["Device"], index),
		inline = true,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable this device matching rule."],
				get = function()
					return M.profile[key].enable
				end,
				set = function(_, value)
					M.profile[key].enable = value
					M:UpdateButtonVisibility()
					M:UpdateButtonText()
				end,
			},
			pattern = {
				order = 2,
				type = "input",
				name = L["Device Name Matching"],
				desc = GetPatternInputDescription,
				width = 1.2,
				get = function()
					return M.profile[key].pattern
				end,
				set = function(_, value)
					M.profile[key].pattern = value
					M:UpdateButtonVisibility()
					M:UpdateButtonText()
				end,
			},
			displayName = {
				order = 3,
				type = "input",
				name = L["Display Name"],
				desc = L["Name shown on the switch button after matching."],
				width = 1.2,
				get = function()
					return M.profile[key].displayName
				end,
				set = function(_, value)
					M.profile[key].displayName = value
					M:UpdateButtonVisibility()
					M:UpdateButtonText()
				end,
			},
		},
	}
end

M:SetSettings(settings)

local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher

---Build the description for the pattern input field.
---Highlights each available output device green (matched) or red (not matched).
---@param pattern string
---@return string
local function GetPatternDescription(pattern)
	local lines = {
		L["Partial or full system device name used for matching (Lua Regex)"],
		" ",
		" ",
		L["Available Output Devices"] .. ":",
		" ",
	}

	local devices = M:GetAllDeviceNames()
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

	local hasPattern = F.Validator.IsNonEmptyString(pattern)
	for _, entry in ipairs(entries) do
		local line = string.format("%s %s", F.Color.String(tostring(entry.index), "cyan-500"), entry.name)
		if hasPattern then
			local ok, matched = pcall(string.match, entry.name, pattern)
			line = F.Color.String(line, ok and matched and "green-500" or "rose-500")
		end
		table.insert(lines, line)
	end

	return table.concat(lines, "\n")
end

local deviceArgs = {}

local function RebuildDeviceArgs()
	if not M.profile or not M.profile.devices then
		return
	end

	for k in pairs(deviceArgs) do
		deviceArgs[k] = nil
	end

	deviceArgs.addDevice = {
		order = 1,
		type = "execute",
		name = L["Add Device"],
		func = function()
			table.insert(M.profile.devices, M.defaultDeviceSetting)
			RebuildDeviceArgs()
			E:RefreshSettings()
		end,
	}

	for index, _ in ipairs(M.profile.devices) do
		local idx = index
		deviceArgs["device" .. idx] = {
			order = idx + 1,
			type = "group",
			name = string.format("%s %d", L["Device"], idx),
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable this device matching rule."],
					get = function()
						local db = M.profile.devices[idx]
						return db and db.enable
					end,
					set = function(_, value)
						local db = M.profile.devices[idx]
						if db then
							db.enable = value
							M:UpdateButtonVisibility()
							M:UpdateButtonText()
						end
					end,
				},
				delete = {
					order = 2,
					type = "execute",
					name = L["Delete this device"],
					confirm = true,
					confirmText = string.format(
						L["Are you sure you want to delete %s?"],
						string.format("%s %d", L["Device"], idx)
					),
					func = function()
						table.remove(M.profile.devices, idx)
						RebuildDeviceArgs()
						E:RefreshSettings()
						M:UpdateButtonVisibility()
						M:UpdateButtonText()
					end,
				},
				divider = E:GetSimpleDivider(3),
				pattern = {
					order = 4,
					type = "input",
					name = L["Device Name Pattern"],
					desc = function()
						local db = M.profile.devices[idx]
						return GetPatternDescription(db and db.pattern or "")
					end,
					width = 1.5,
					get = function()
						local db = M.profile.devices[idx]
						return db and db.pattern or ""
					end,
					set = function(_, value)
						local db = M.profile.devices[idx]
						if db then
							db.pattern = value
							M:UpdateButtonVisibility()
							M:UpdateButtonText()
						end
					end,
				},
				displayName = {
					order = 5,
					type = "input",
					name = L["Display Name"],
					desc = L["Name shown on the switch button after matching."],
					width = 1.5,
					get = function()
						local db = M.profile.devices[idx]
						return db and db.displayName or ""
					end,
					set = function(_, value)
						local db = M.profile.devices[idx]
						if db then
							db.displayName = value
							M:UpdateButtonVisibility()
							M:UpdateButtonText()
						end
					end,
				},
			},
		}
	end
end

-- Expose so Module.lua can call this after profile is ready.
M.RebuildDeviceSettings = RebuildDeviceArgs

local settings = {
	mode = {
		order = 3,
		type = "select",
		name = L["Mode"],
		width = "full",
		values = {
			manual = L["Manual Switch"],
			alwaysPrimary = L["Always Primary Device"],
		},
		get = function()
			return M.profile.mode
		end,
		set = function(_, value)
			M.profile.mode = value
			M:ApplyMode()
			M:UpdateUI()
			E:RefreshSettings()
		end,
	},
	alwaysPrimaryDesc = {
		order = 4,
		type = "group",
		inline = true,
		name = " ",
		hidden = function()
			return M.profile.mode ~= "alwaysPrimary"
		end,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = string.format(
					"%s\n\n%s %s\n\n%s %s",
					L["Automatically resets to the primary audio device when audio devices change."],
					F.Color.String(L["Warning"] .. ":", "yellow-500"),
					L["The reset will cause 2-3 seconds of game freeze while the sound system restarts. This is unavoidable due to how the game handles audio device changes."],
					F.Color.String(L["Tip"] .. ":", "cyan-500"),
					L["If your audio device frequently disconnects and reconnects, consider using the manual mode instead to avoid frequent freezes."]
				),
			},
			autoResetOnEnter = {
				order = 2,
				type = "toggle",
				name = L["Reset on Enter World"],
				desc = L["Automatically reset to the primary audio device when entering the world. This may slightly increase loading screen time."],
				get = function()
					return M.profile.autoResetOnEnter
				end,
				set = function(_, value)
					M.profile.autoResetOnEnter = value
				end,
			},
		},
	},
	notice = {
		order = 5,
		type = "group",
		inline = true,
		name = " ",
		hidden = function()
			return M.profile.mode ~= "manual"
		end,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = string.format(
					"%s: %s",
					F.Color.String(L["Notice"], "yellow-500"),
					L["The button is hidden when fewer than 2 devices are configured and matched."]
				),
			},
		},
	},
	ui = {
		order = 11,
		hidden = function()
			return M.profile.mode ~= "manual"
		end,
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
					lock = {
						order = 3,
						type = "toggle",
						name = L["Lock"],
						desc = L["Lock the UI in place."],
						get = function()
							return M.profile.ui.general.lock
						end,
						set = function(_, value)
							M.profile.ui.general.lock = value
							if M.UI.Button then
								F.Mover.SetMovable(M.UI.Button, not value)
							end
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
		order = 12,
		type = "group",
		name = L["Devices"],
		childGroups = "tab",
		hidden = function()
			return M.profile.mode ~= "manual"
		end,
		args = deviceArgs,
	},
}

settings.ui.args.font = E:GetFontSettings(function()
	return M.profile.ui.font
end, {
	asGroup = true,
	startOrder = 2,
	groupName = L["Font Settings"],
	groupOptions = { inline = true },
	callback = function()
		M:UpdateUI()
	end,
})

M:SetSettings(settings)

local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Guild Helper") ---@class GuildHelper

local settings = {
	ui = {
		order = 11,
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
						desc = L["Set the width of the UI frame."],
						min = 100,
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
					spacingBetweenElements = {
						order = 2,
						type = "range",
						name = L["Spacing"],
						desc = L["Set the spacing between title and buttons."],
						min = 0,
						max = 20,
						step = 1,
						get = function()
							return M.profile.ui.general.spacingBetweenElements
						end,
						set = function(_, value)
							M.profile.ui.general.spacingBetweenElements = value
							M:UpdateUI()
						end,
					},
					showTooltip = {
						order = 3,
						type = "toggle",
						name = L["Show Tooltip"],
						desc = L["Show tooltips when hovering over UI elements."],
						get = function()
							return M.profile.ui.general.showTooltip
						end,
						set = function(_, value)
							M.profile.ui.general.showTooltip = value
						end,
					},
					lock = {
						order = 4,
						type = "toggle",
						name = L["Lock"],
						desc = L["Lock the UI in place."],
						get = function()
							return M.profile.ui.general.lock
						end,
						set = function(_, value)
							M.profile.ui.general.lock = value
							if M.UI.Title then
								F.Mover.SetMovable(M.UI.Title, not value)
							end
						end,
					},
				},
			},
			title = {
				order = 2,
				type = "group",
				name = L["Title"],
				inline = true,
				args = {
					height = {
						order = 1,
						type = "range",
						name = L["Height"],
						desc = L["Set the height of the title bar."],
						min = 20,
						max = 60,
						step = 1,
						get = function()
							return M.profile.ui.title.height
						end,
						set = function(_, value)
							M.profile.ui.title.height = value
							M:UpdateUI()
						end,
					},
				},
			},
			button = {
				order = 3,
				type = "group",
				name = L["Button"],
				inline = true,
				args = {
					height = {
						order = 1,
						type = "range",
						name = L["Height"],
						desc = L["Set the height of the buttons."],
						min = 24,
						max = 60,
						step = 1,
						get = function()
							return M.profile.ui.button.height
						end,
						set = function(_, value)
							M.profile.ui.button.height = value
							M:UpdateUI()
						end,
					},
					spacing = {
						order = 2,
						type = "range",
						name = L["Spacing"],
						desc = L["Set the spacing between buttons."],
						min = 0,
						max = 20,
						step = 1,
						get = function()
							return M.profile.ui.button.spacing
						end,
						set = function(_, value)
							M.profile.ui.button.spacing = value
							M:UpdateUI()
						end,
					},
				},
			},
		},
	},
	invite = {
		order = 12,
		type = "group",
		name = L["Invite"],
		args = {
			channels = {
				order = 1,
				type = "input",
				name = L["Community Channels"],
				desc = L["Community channel names to monitor, separated by commas."],
				multiline = true,
				width = "full",
			},
		},
	},
	kick = {
		order = 13,
		type = "group",
		name = L["Kick"],
		args = {
			protection = {
				order = 1,
				type = "group",
				name = L["Protection Rules"],
				inline = true,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable Protection"],
						desc = L["Enable protection rules to prevent kicking certain members."],
						get = function()
							return M.profile.kick.protection.enabled
						end,
						set = function(_, value)
							M.profile.kick.protection.enabled = value
						end,
					},
					hasPublicNote = {
						order = 2,
						type = "toggle",
						name = L["Has Public Note"],
						desc = L["Protect members with a public note."],
						get = function()
							return M.profile.kick.protection.hasPublicNote
						end,
						set = function(_, value)
							M.profile.kick.protection.hasPublicNote = value
						end,
						hidden = function()
							return not M.profile.kick.protection.enabled
						end,
					},
					hasOfficerNote = {
						order = 3,
						type = "toggle",
						name = L["Has Officer Note"],
						desc = L["Protect members with an officer note."],
						get = function()
							return M.profile.kick.protection.hasOfficerNote
						end,
						set = function(_, value)
							M.profile.kick.protection.hasOfficerNote = value
						end,
						hidden = function()
							return not M.profile.kick.protection.enabled
						end,
					},
					guildRanks = {
						order = 4,
						type = "input",
						name = L["Protected Guild Ranks"],
						desc = L["Guild rank names to protect, separated by commas."],
						width = "full",
						hidden = function()
							return not M.profile.kick.protection.enabled
						end,
					},
				},
			},
			rules = {
				order = 2,
				type = "group",
				name = L["Kick Rules"],
				inline = true,
				args = {
					desc = {
						order = 1,
						type = "group",
						name = L["Description"],
						args = {
							desc = {
								order = 1,
								type = "description",
								name = L["If any of the enabled rules are met, the target will be considered to be kicked."],
							},
						},
					},
					levelRange = {
						order = 1,
						type = "group",
						name = function()
							return L["Rule"]
								.. ": "
								.. F.Color.String(
									L["Level Range"],
									M.profile.kick.rules.levelRange.enabled and "emerald-500" or "rose-600"
								)
						end,
						inline = true,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function()
									return M.profile.kick.rules.levelRange.enabled
								end,
								set = function(_, value)
									M.profile.kick.rules.levelRange.enabled = value
								end,
							},
							minLevel = {
								order = 2,
								type = "range",
								name = L["Min Level"],
								desc = L["Minimum level to kick."],
								min = 1,
								max = 80,
								step = 1,
								get = function()
									return M.profile.kick.rules.levelRange.minLevel
								end,
								set = function(_, value)
									M.profile.kick.rules.levelRange.minLevel = value
								end,
								hidden = function()
									return not M.profile.kick.rules.levelRange.enabled
								end,
							},
							maxLevel = {
								order = 3,
								type = "range",
								name = L["Max Level"],
								desc = L["Maximum level to kick."],
								min = 1,
								max = 80,
								step = 1,
								get = function()
									return M.profile.kick.rules.levelRange.maxLevel
								end,
								set = function(_, value)
									M.profile.kick.rules.levelRange.maxLevel = value
								end,
								hidden = function()
									return not M.profile.kick.rules.levelRange.enabled
								end,
							},
						},
					},
					longOffline = {
						order = 2,
						type = "group",
						name = function()
							return L["Rule"]
								.. ": "
								.. F.Color.String(
									L["Long Offline"],
									M.profile.kick.rules.longOffline.enabled and "emerald-500" or "rose-600"
								)
						end,
						inline = true,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function()
									return M.profile.kick.rules.longOffline.enabled
								end,
								set = function(_, value)
									M.profile.kick.rules.longOffline.enabled = value
								end,
							},
							minHours = {
								order = 2,
								type = "range",
								name = L["Min Offline Hours"],
								desc = L["Kick members offline for more than this many hours."],
								min = 1,
								max = 2160,
								step = 1,
								get = function()
									return M.profile.kick.rules.longOffline.minHours
								end,
								set = function(_, value)
									M.profile.kick.rules.longOffline.minHours = value
								end,
								hidden = function()
									return not M.profile.kick.rules.longOffline.enabled
								end,
							},
						},
					},
					noteMark = {
						order = 3,
						type = "group",
						name = function()
							return L["Rule"]
								.. ": "
								.. F.Color.String(
									L["Note Mark"],
									M.profile.kick.rules.noteMark.enabled and "emerald-500" or "rose-600"
								)
						end,
						inline = true,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function()
									return M.profile.kick.rules.noteMark.enabled
								end,
								set = function(_, value)
									M.profile.kick.rules.noteMark.enabled = value
								end,
							},
							useRegex = {
								order = 2,
								type = "toggle",
								name = L["Use Regex"],
								desc = L["Treat patterns as regular expressions."],
								get = function()
									return M.profile.kick.rules.noteMark.useRegex
								end,
								set = function(_, value)
									M.profile.kick.rules.noteMark.useRegex = value
								end,
								hidden = function()
									return not M.profile.kick.rules.noteMark.enabled
								end,
							},
							patterns = {
								order = 3,
								type = "input",
								name = L["Patterns"],
								desc = L["Patterns to match in public or officer note, separated by commas."],
								multiline = true,
								width = "full",
								hidden = function()
									return not M.profile.kick.rules.noteMark.enabled
								end,
							},
						},
					},
					guildRank = {
						order = 4,
						type = "group",
						name = function()
							return L["Rule"]
								.. ": "
								.. F.Color.String(
									L["Guild Ranks"],
									M.profile.kick.rules.guildRank.enabled and "emerald-500" or "rose-600"
								)
						end,
						inline = true,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Only apply kick rules to specified guild ranks."],
								get = function()
									return M.profile.kick.rules.guildRank.enabled
								end,
								set = function(_, value)
									M.profile.kick.rules.guildRank.enabled = value
								end,
							},
							ranks = {
								order = 2,
								type = "input",
								name = L["Guild Ranks"],
								desc = L["Guild rank names to target, separated by commas."],
								width = "full",
								hidden = function()
									return not M.profile.kick.rules.guildRank.enabled
								end,
							},
						},
					},
				},
			},
		},
	},
}

F.Table.Extend(
	settings.ui.args.title.args,
	E:GetFontSettings(function()
		return M.profile.ui.title.font
	end, {
		startOrder = 2,
		callback = function()
			M:UpdateUI()
		end,
	})
)

F.Table.Extend(
	settings.ui.args.button.args,
	E:GetFontSettings(function()
		return M.profile.ui.button.font
	end, {
		startOrder = 3,
		callback = function()
			M:UpdateUI()
		end,
	})
)

E:SetStringListSetting(settings.invite.args.channels, function()
	return M.profile.invite.channels
end)

E:SetStringListSetting(settings.kick.args.protection.args.guildRanks, function()
	return M.profile.kick.protection.guildRanks
end)

E:SetStringListSetting(settings.kick.args.rules.args.noteMark.args.patterns, function()
	return M.profile.kick.rules.noteMark.patterns
end)

E:SetStringListSetting(settings.kick.args.rules.args.guildRank.args.ranks, function()
	return M.profile.kick.rules.guildRank.ranks
end)

M:SetSettings(settings)

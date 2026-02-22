local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

---@class GuildHelper
local defaults = {
	profile = {
		enabled = false,
		ui = {
			general = {
				width = 150,
				spacingBetweenElements = 4,
				showTooltip = true,
			},
			title = {
				height = 30,
				font = {
					name = F.Font.DefaultName,
					style = F.Font.DefaultStyle,
					height = 14,
				},
			},
			button = {
				height = 36,
				spacing = 4,
				font = {
					name = F.Font.DefaultName,
					style = F.Font.DefaultStyle,
					height = 13,
				},
			},
		},
		invite = {
			channels = { L["Test Community"] },
		},
		kick = {
			protection = {
				enabled = true,
				hasPublicNote = true,
				hasOfficerNote = true,
				guildRanks = {}, ---@type string[]
			},
			rules = {
				levelRange = {
					enabled = false,
					minLevel = 1,
					maxLevel = 79,
				},
				longOffline = {
					enabled = true,
					minHours = 24 * 30,
				},
				noteMark = {
					enabled = false,
					useRegex = false,
					patterns = {}, ---@type string[]
				},
				guildRank = {
					enabled = true,
					ranks = { L["Newcome"] },
				},
			},
		},
	},
}

E:Module("Guild Helper"):SetDefaults(defaults)

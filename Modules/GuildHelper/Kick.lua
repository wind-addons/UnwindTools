local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Guild Helper") ---@class GuildHelper

---@class GuildHelper.KickManager
---@field Queue string[]
---@field CurrentList string[]
---@field Button Button? The invite button UI element
---@field ButtonTitle string The title of the invite button
---@field ButtonValueColorTemplate ColorTemplate The color template for the button value
---@field Template string The macro template for inviting players
---@field CallbackMessage string The callback message identifier
local Manager = {
	Queue = {},
	CurrentList = {},
	Button = nil,
	ButtonTitle = L["Kick"],
	ButtonValueColorTemplate = "cyan-500",
	Template = [[/run print("kick %s")]],
	-- Template = [[/gremove %s]],
	CallbackMessage = "GHKICKCLK",
}

Manager.UpdateButtonState = M.InviteManager.UpdateButtonState

---@param text string
---@param patterns string[]
---@param useRegex boolean
---@return boolean
local function MatchPatterns(text, patterns, useRegex)
	if not text or text == "" then
		return false
	end

	for _, pattern in pairs(patterns) do
		if useRegex then
			if string.match(text, pattern) then
				return true
			end
		else
			if string.find(text, pattern, 1, true) then
				return true
			end
		end
	end
	return false
end

---Calculate offline hours from guild roster info
---@param index number
---@return number hours
local function GetOfflineHours(index)
	local years, months, days, hours = GetGuildRosterLastOnline(index)
	return (years or 0) * 8760 + (months or 0) * 720 + (days or 0) * 24 + (hours or 0)
end

---Check if a member should be protected from being kicked
---@param publicNote string?
---@param officerNote string?
---@param rankName string?
---@return boolean
local function IsProtected(publicNote, officerNote, rankName)
	local protection = M.profile.kick.protection
	if not protection.enabled then
		return false
	end

	if protection.hasPublicNote and publicNote and publicNote ~= "" then
		return true
	end

	if protection.hasOfficerNote and officerNote and officerNote ~= "" then
		return true
	end

	if rankName and tContains(protection.guildRanks, rankName) then
		return true
	end

	return false
end

---Check if a member matches any kick rule
---@param rankName string?
---@param level number?
---@param offlineHours number
---@param publicNote string?
---@param officerNote string?
---@return boolean
local function MatchesKickRule(rankName, level, offlineHours, publicNote, officerNote)
	local rules = M.profile.kick.rules

	if rules.guildRank.enabled and rankName and tContains(rules.guildRank.ranks, rankName) then
		return true
	end

	if
		rules.levelRange.enabled
		and level
		and level >= rules.levelRange.minLevel
		and level <= rules.levelRange.maxLevel
	then
		return true
	end

	if rules.longOffline.enabled and offlineHours >= rules.longOffline.minHours then
		return true
	end

	if
		rules.noteMark.enabled
		and (
			MatchPatterns(publicNote or "", rules.noteMark.patterns, rules.noteMark.useRegex)
			or MatchPatterns(officerNote or "", rules.noteMark.patterns, rules.noteMark.useRegex)
		)
	then
		return true
	end

	return false
end

function Manager:FullyRefresh()
	table.wipe(self.Queue)
	table.wipe(self.CurrentList)

	for i = 1, GetNumGuildMembers() do
		local name, rankName, _, level, _, _, publicNote, officerNote = GetGuildRosterInfo(i)

		if not name then
			-- skip
		elseif IsProtected(publicNote, officerNote, rankName) then
			-- skip protected members
		else
			local offlineHours = GetOfflineHours(i)
			if MatchesKickRule(rankName, level, offlineHours, publicNote, officerNote) then
				table.insert(self.Queue, name)
			end
		end
	end

	M:Debug("Refreshed kick queue:", #self.Queue, "members")
end

---Get the current list of members to be kicked
---@return string[] The current list of members to be kicked
function Manager:GetCurrentList()
	return self.CurrentList
end

E:RegisterCallback(Manager.CallbackMessage, function()
	wipe(Manager.CurrentList)
	Manager:UpdateButtonState()
end)

M.KickManager = Manager

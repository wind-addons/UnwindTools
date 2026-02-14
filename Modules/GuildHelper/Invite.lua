local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Guild Helper") ---@class GuildHelper

---@class GuildHelper.InviteManager
---@field Queue string[] The queue of invitees to be processed
---@field CurrentList string[] The current list of invitees being processed
---@field ChannelIDs table<string, boolean> A table of loaded invite channel IDs
---@field NumberOfLoadedChannels number The number of loaded invite channels
---@field Button Button? The invite button UI element
---@field ButtonTitle string The title of the invite button
---@field ButtonValueColorTemplate ColorTemplate The color template for the button value
---@field Template string The macro template for inviting players
---@field CallbackMessage string The callback message identifier
local Manager = {
	Queue = {},
	CurrentList = {},
	ChannelIDs = {},
	NumberOfLoadedChannels = 0,
	Button = nil,
	ButtonTitle = L["Invite"],
	ButtonValueColorTemplate = "amber-500",
	-- Template = [[/run print("invite %s")]],
	Template = [[/ginvite %s]],
	CallbackMessage = "GHINVCLK",
}

---Add a player to the invite queue
---@param author string The name of the player to invite
---@param community string The community identifier
function Manager:HandleCommunityChatMessage(author, community)
	if self.NumberOfLoadedChannels == 0 then
		return
	end

	local id = string.match(community, "Community:(.-):")
	if id and self.ChannelIDs[tostring(id)] then
		tInsertUnique(self.Queue, author)
		self:UpdateButtonState()

		M:Debug("Invite Queue:", self.Queue)
		M:Debug("Current List:", self.CurrentList)
	end
end

---Refresh the list of invite channels
function Manager:RefreshChannelList()
	wipe(self.ChannelIDs)
	self.NumberOfLoadedChannels = 0

	local channelSet = {}
	for _, name in ipairs(M.profile.invite.channels) do
		channelSet[name] = true
	end

	local channels = { GetChannelList() }
	for i = 2, #channels, 3 do
		local id = channels[i] and string.match(tostring(channels[i]), "Community:(.-):")
		if id then
			local info = C_Club.GetClubInfo(id)
			if info and channelSet[info.name] then
				self.ChannelIDs[id] = true
				self.NumberOfLoadedChannels = self.NumberOfLoadedChannels + 1
			end
		end
	end

	M:Debug("Loaded", self.NumberOfLoadedChannels, "invite channels.", self.ChannelIDs)
end

function Manager:UpdateButtonState()
	assert(self.Button, "The button must be set before updating its state")

	while #self.CurrentList < 5 and #self.Queue > 0 do
		tInsertUnique(self.CurrentList, tremove(self.Queue, 1))
	end

	if #self.CurrentList == 0 then
		self.Button:Disable()
		self.Button:SetText(self.ButtonTitle)
		return
	end

	local macroLines = {}
	for _, name in ipairs(self.CurrentList) do
		table.insert(macroLines, string.format(self.Template, name))
	end

	table.insert(macroLines, E:GetCallbackMacroLine(self.CallbackMessage))

	self.Button:Enable()
	self.Button:SetAttribute("macrotext1", table.concat(macroLines, "\n"))

	local amountString = F.Color.String(tostring(#self.Queue + #self.CurrentList), self.ButtonValueColorTemplate)
	self.Button:SetText(string.format("%s: %s", self.ButtonTitle, string.format(L["%s left"], amountString)))
end

---Get the current list of invitees
---@return string[] The current list of invitees
function Manager:GetCurrentList()
	return self.CurrentList
end

E:RegisterCallback(Manager.CallbackMessage, function()
	table.wipe(Manager.CurrentList)
	Manager:UpdateButtonState()
end)

M.InviteManager = Manager

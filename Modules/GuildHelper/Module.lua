local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Guild Helper") ---@class GuildHelper: WindModule
M:SetCategory("social"):SetTitle(L["Guild Helper"]):SetID("guildHelper")

function M:OnProfileChanged()
	self:UpdateUI()
end

function M:OnEnable()
	self:UpdateUI()
	self.UI.Title:Show()
	self.UI.Container:Show()

	self.InviteManager.Button = M.UI.InviteButton
	self.KickManager.Button = M.UI.KickButton
	self.InviteManager:RefreshChannelList()
	self.InviteManager:UpdateButtonState()
	self.KickManager:UpdateButtonState()

	self:RegisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")

	self:Debug("Module enabled.")
end

function M:OnDisable()
	self.UI.Title:Hide()
	self.UI.Container:Hide()

	self:UnregisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")

	self:Debug("Module disabled.")
end

function M:CHAT_MSG_COMMUNITIES_CHANNEL(_, _, author, _, community)
	if F.Validator.IsNonEmptyString(author) and F.Validator.IsNonEmptyString(community) then
		E:Debug("CHAT_MSG_COMMUNITIES_CHANNEL", author, community)
		self.InviteManager:HandleCommunityChatMessage(author, community)
	end
end

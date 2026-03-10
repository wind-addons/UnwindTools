local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Guild Helper") ---@class GuildHelper: WindModule
M:SetCategory("social"):SetTitle(L["Guild Helper"]):SetID("guildHelper")

---@type table<string, fun(): Button?>
local buttonGetters = {
	invite = function()
		return M.UI.InviteButton
	end,
	refreshKick = function()
		return M.UI.RefreshKickButton
	end,
	kick = function()
		return M.UI.KickButton
	end,
}

function M:OnProfileChanged()
	self:UpdateUI()
	self:UpdateBindings()
end

function M:UpdateBindings()
	if not self.bindingOwner then
		return
	end

	local keybindings = self.profile.ui.button.keybindings
	local frame = self.bindingOwner

	ClearOverrideBindings(frame)

	local usedKeys = {}
	for name, getButton in pairs(buttonGetters) do
		local key = keybindings[name]

		if key and key ~= "" and not usedKeys[key] then
			usedKeys[key] = true
			self.bindings = self.bindings or {}
			self.bindings[name] = key
			SetOverrideBindingClick(frame, true, key, getButton():GetName())
		end
	end
end

function M:OnEnable()
	self:UpdateUI()

	self.bindingOwner = CreateFrame("Frame")
	self:UpdateBindings()

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

	if self.bindingOwner then
		ClearOverrideBindings(self.bindingOwner)
		self.bindingOwner = nil
	end

	self:Debug("Module disabled.")
end

function M:CHAT_MSG_COMMUNITIES_CHANNEL(_, _, author, _, community)
	if F.Validator.IsNonEmptyString(author) and F.Validator.IsNonEmptyString(community) then
		E:Debug("CHAT_MSG_COMMUNITIES_CHANNEL", author, community)
		self.InviteManager:HandleCommunityChatMessage(author, community)
	end
end

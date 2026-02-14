local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local S = E:Module("Skinner") ---@class Skinner
local M = E:Module("Guild Helper") ---@class GuildHelper

---@class GuildHelper.UI
M.UI = {}

function M.UpdateTitle()
	if not M.UI.Title then
		local frame = CreateFrame(
			"Button",
			E.name .. "GuildHelperTitle",
			UIParent,
			"TooltipBorderBackdropTemplate, BackdropTemplate"
		) --[[@as Frame]]
		frame:SetBackdropColor(0, 0, 0, 0.68)
		frame:SetSize(M.profile.ui.general.width, M.profile.ui.title.height)
		frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
		S:Frame(frame, { template = "Transparent", shadow = true })

		frame.Text = frame:CreateFontString(nil, "OVERLAY")
		F.Font.Set(frame.Text, M.profile.ui.title.font)
		frame.Text:SetText(F.Color.StringInWindStyle(L["Guild Helper"]))
		frame.Text:SetPoint("CENTER")
		frame.Text:SetJustifyH("CENTER")

		frame:SetScript("OnEnter", function(self)
			if not M.profile.ui.general.showTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4)
			GameTooltip:AddLine(L["Double click to collapse/expand the buttons."])
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		frame:SetScript("OnDoubleClick", function()
			M.UI.Container:SetShown(not M.UI.Container:IsShown())
		end)

		F.Mover.New(frame, { id = "GuildHelperTitleBar" })
		F.Mover.Restore(frame)

		M.UI.Title = frame
	end

	M.UI.Title:SetSize(M.profile.ui.general.width, M.profile.ui.title.height)
	F.Font.Set(M.UI.Title.Text, M.profile.ui.title.font)
end

function M.UpdateContainer()
	if not M.UI.Container then
		local frame = CreateFrame(
			"Frame",
			E.name .. "GuildHelperContainer",
			UIParent,
			"TooltipBorderBackdropTemplate, BackdropTemplate"
		) --[[@as Frame]]
		frame:SetBackdropColor(0, 0, 0, 0.68)
		S:Frame(frame, { template = "Transparent", shadow = true })

		M.UI.Container = frame
	end

	M.UI.Container:SetSize(M.profile.ui.general.width, M.profile.ui.button.height * 3 + M.profile.ui.button.spacing * 4)
	M.UI.Container:SetPoint("TOP", M.UI.Title, "BOTTOM", 0, -M.profile.ui.general.spacingBetweenElements)
end

function M.UpdateInviteButton()
	assert(M.UI.Container, "Container must be created before InviteButton")

	if not M.UI.InviteButton then
		local button = CreateFrame(
			"Button",
			E.name .. "GuildHelperInviteButton",
			M.UI.Container,
			"SharedButtonTemplate, SecureActionButtonTemplate"
		)
		button:SetText(L["Invite"])
		button:RegisterForClicks("AnyUp", "AnyDown")
		button:SetAttribute("type*", "macro")

		button:SetScript("OnEnter", function()
			if not M.profile.ui.general.showTooltip then
				return
			end
			GameTooltip:SetOwner(M.UI.Container, "ANCHOR_BOTTOM", 0, -5)
			GameTooltip:SetText(L["Invites Players"])
			local list = M.InviteManager:GetCurrentList()
			if not list or #list == 0 then
				GameTooltip:AddLine(F.Color.String(L["No players in the invite queue."], "gray-500"))
			else
				GameTooltip:AddLine(L["Players in the invite queue"] .. ":")
				GameTooltip:AddLine(" ")
				for _, name in ipairs(list) do
					GameTooltip:AddLine("|cffffffff" .. name .. "|r")
				end
			end
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		S:Button(button, { shadow = false, template = "Default" })

		M.UI.InviteButton = button --[[@as SecureActionButtonTemplate]]
	end

	M.UI.InviteButton:SetSize(M.profile.ui.general.width - 4 * 2, M.profile.ui.button.height)
	M.UI.InviteButton:SetPoint("TOP", M.UI.Container, "TOP", 0, -M.profile.ui.button.spacing)
	F.Font.Set(M.UI.InviteButton:GetFontString(), M.profile.ui.button.font)
end

function M.UpdateRefreshKickButton()
	assert(M.UI.Container, "Container must be created before RefreshKickButton")
	assert(M.UI.InviteButton, "InviteButton must be created before RefreshKickButton")

	if not M.UI.RefreshKickButton then
		local button =
			CreateFrame("Button", E.name .. "GuildHelperRefreshKickButton", M.UI.Container, "SharedButtonTemplate")
		button:RegisterForClicks("AnyUp")
		button:SetText(L["Refresh Kick List"])

		button:SetScript("OnEnter", function()
			if not M.profile.ui.general.showTooltip then
				return
			end
			GameTooltip:SetOwner(M.UI.Container, "ANCHOR_BOTTOM", 0, -5)
			GameTooltip:SetText(L["Refresh"])
			GameTooltip:AddLine(L["Recalculates the kick list based on the current guild members and kick settings."])
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		button:SetScript("OnClick", function()
			M.KickManager:FullyRefresh()
			M.KickManager:UpdateButtonState()
		end)

		S:Button(button, { shadow = false, template = "Default" })

		M.UI.RefreshKickButton = button
	end

	M.UI.RefreshKickButton:SetSize(M.profile.ui.general.width - 4 * 2, M.profile.ui.button.height)
	M.UI.RefreshKickButton:SetPoint("TOP", M.UI.InviteButton, "BOTTOM", 0, -M.profile.ui.button.spacing)
	F.Font.Set(M.UI.RefreshKickButton:GetFontString(), M.profile.ui.button.font)
end

function M.UpdateKickButton()
	assert(M.UI.Container, "Container must be created before KickButton")
	assert(M.UI.RefreshKickButton, "RefreshKickButton must be created before KickButton")

	if not M.UI.KickButton then
		local button = CreateFrame(
			"Button",
			E.name .. "GuildHelperKickButton",
			M.UI.Container,
			"SharedButtonTemplate, SecureActionButtonTemplate"
		)
		button:SetText(L["Kick"])
		button:RegisterForClicks("AnyUp", "AnyDown")
		button:SetAttribute("type*", "macro")

		button:SetScript("OnEnter", function()
			if not M.profile.ui.general.showTooltip then
				return
			end
			GameTooltip:SetOwner(M.UI.Container, "ANCHOR_BOTTOM", 0, -5)
			GameTooltip:SetText(L["Kick"])
			local list = M.KickManager:GetCurrentList()
			if not list or #list == 0 then
				GameTooltip:AddLine(F.Color.String(L["No players to kick."], "gray-500"))
			else
				GameTooltip:AddLine(L["Players to be kicked"] .. ":")
				GameTooltip:AddLine(" ")
				for _, name in ipairs(list) do
					GameTooltip:AddLine("|cffffffff" .. name .. "|r")
				end
			end
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		S:Button(button, { shadow = false, template = "Default" })

		M.UI.KickButton = button --[[@as SecureActionButtonTemplate]]
	end

	M.UI.KickButton:SetSize(M.profile.ui.general.width - 4 * 2, M.profile.ui.button.height)
	M.UI.KickButton:SetPoint("TOP", M.UI.RefreshKickButton, "BOTTOM", 0, -M.profile.ui.button.spacing)
	F.Font.Set(M.UI.KickButton:GetFontString(), M.profile.ui.button.font)
end

function M:UpdateUI()
	self.UpdateTitle()
	self.UpdateContainer()
	self.UpdateInviteButton()
	self.UpdateRefreshKickButton()
	self.UpdateKickButton()
end

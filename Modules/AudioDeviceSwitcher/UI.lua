local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local S = E:Module("Skinner") ---@class Skinner
local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher

---@class AudioDeviceSwitcher.UI
M.UI = {}

function M.UpdateButtonBackdrop()
	if not M.UI.Button then
		return
	end

	local isShown = M.profile.ui.general.transparent
	local button = M.UI.Button

	if button.__bg then
		button.__bg:SetShown(isShown)
	elseif button.backdrop then
		button.backdrop:SetShown(isShown)
	elseif button.Left and button.Middle and button.Right then
		button.Left:SetShown(isShown)
		button.Middle:SetShown(isShown)
		button.Right:SetShown(isShown)
	end
end

function M.UpdateButton()
	if not M.UI.Button then
		local button = CreateFrame("Button", E.name .. "AudioDeviceSwitcherButton", UIParent, "SharedButtonTemplate")
		button:SetPoint("CENTER", UIParent, "CENTER", 240, -200)
		button:RegisterForClicks("AnyUp")
		button:SetText(L["Audio Device Switcher"])

		button:SetScript("OnClick", function(_, mouseButton)
			if mouseButton ~= "LeftButton" then
				return
			end

			M:SwitchDevice()
		end)

		button:SetScript("OnEnter", function(self)
			if M.profile.ui.general.mouseover then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			end

			if not M.profile.ui.general.showTooltip then
				return
			end

			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4)
			GameTooltip:AddLine(L["Audio Device Switcher"])
			GameTooltip:AddLine(L["Click to switch to the next configured device."], 1, 1, 1, true)
			GameTooltip:Show()
		end)

		button:SetScript("OnLeave", function(self)
			if M.profile.ui.general.mouseover then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 0)
			end
			GameTooltip:Hide()
		end)

		S:Button(button, { template = "Default", shadow = true })

		F.Mover.New(button, { enabled = not M.profile.ui.general.lock, id = "AudioDeviceSwitcherButton" })
		F.Mover.Restore(button)

		M.UI.Button = button
	end

	local button = M.UI.Button
	button:SetSize(M.profile.ui.general.width, M.profile.ui.general.height)
	button:SetAlpha(M.profile.ui.general.mouseover and 0 or 1)
	F.Font.Set(button:GetFontString(), M.profile.ui.font)

	M.UpdateButtonBackdrop()
end

function M:UpdateButtonText()
	if not self.UI.Button then
		return
	end

	self.UI.Button:SetText(self:GetCurrentDeviceName())
end

function M:UpdateButtonVisibility()
	if not self.UI.Button then
		return
	end

	self.UI.Button:SetShown(#self:GetConfiguredDevices() > 1)
end

function M:UpdateUI()
	if self.profile.mode == "alwaysPrimary" then
		if self:IsHooked("Sound_GameSystem_RestartSoundSystem") then
			self:Unhook("Sound_GameSystem_RestartSoundSystem")
		end
		if self.UI.Button then
			self.UI.Button:Hide()
		end
		return
	end

	if not self:IsHooked("Sound_GameSystem_RestartSoundSystem") then
		self:SecureHook("Sound_GameSystem_RestartSoundSystem", "UpdateButtonText")
	end

	self.UpdateButton()
	self:UpdateButtonVisibility()
	self:UpdateButtonText()
end

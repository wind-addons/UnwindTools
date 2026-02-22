local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher: WindModule
M:SetCategory("system"):SetTitle(L["Audio Device Switcher"]):SetID("audioDeviceSwitcher")

function M:OnInitialize()
	self.RebuildDeviceSettings()
end

function M:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:ApplyMode()

	self:UpdateUI()

	self:Debug("Module enabled.")
end

function M:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("CVAR_UPDATE")
	self:UnregisterEvent("VOICE_CHAT_OUTPUT_DEVICES_UPDATED")

	if self.UI and self.UI.Button then
		self.UI.Button:Hide()
	end

	self:Debug("Module disabled.")
end

function M:OnProfileChanged()
	self.RebuildDeviceSettings()
	self:ApplyMode()
	self:UpdateUI()
end

---Register or unregister events based on the current mode.
function M:ApplyMode()
	if self.profile.mode == "alwaysPrimary" then
		self:UnregisterEvent("CVAR_UPDATE")
		self:RegisterEvent("VOICE_CHAT_OUTPUT_DEVICES_UPDATED", "AutoResetPrimaryDevice")
	else
		self:UnregisterEvent("VOICE_CHAT_OUTPUT_DEVICES_UPDATED")
		self:RegisterEvent("CVAR_UPDATE")
	end
end

function M:PLAYER_ENTERING_WORLD()
	if self.profile.mode == "alwaysPrimary" then
		if self.profile.autoResetOnEnter then
			self:AutoResetPrimaryDevice()
		end
	else
		self:UpdateButtonVisibility()
		self:UpdateButtonText()
	end
end

function M:CVAR_UPDATE(_, cvarName)
	if cvarName ~= "Sound_OutputDriverIndex" then
		return
	end

	RunNextFrame(function()
		self:UpdateButtonText()
	end)
end

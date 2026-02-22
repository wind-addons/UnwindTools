local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher: WindModule
M:SetCategory("system"):SetTitle(L["Audio Device Switcher"]):SetID("audioDeviceSwitcher")

function M:OnInitialize()
	if self._hasSoundSystemHook then
		return
	end

	hooksecurefunc("Sound_GameSystem_RestartSoundSystem", function()
		self:UpdateButtonText()
	end)

	self._hasSoundSystemHook = true
end

function M:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("CVAR_UPDATE")

	self:UpdateUI()

	self:Debug("Module enabled.")
end

function M:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("CVAR_UPDATE")

	if self.UI and self.UI.Button then
		self.UI.Button:Hide()
	end

	self:Debug("Module disabled.")
end

function M:OnProfileChanged()
	self:UpdateUI()
end

function M:PLAYER_ENTERING_WORLD()
	self:UpdateButtonVisibility()
	self:UpdateButtonText()
end

function M:CVAR_UPDATE(_, cvarName)
	if cvarName ~= "Sound_OutputDriverIndex" then
		return
	end

	RunNextFrame(function()
        self:UpdateButtonText()
    end)
end

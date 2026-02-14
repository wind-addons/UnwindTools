local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Skinner") ---@class Skinner: WindModule
M:SetTitle(L["Skinner"])

---@class SkinnerStyleOptions
---@field template? "Default" | "Transparent"
---@field createBackdrop?  boolean
---@field shadow? boolean

---@class SkinnerPrototype
local SkinnerPrototype = {}

---Reskin the frame with the specified style.
---@param frame Frame The frame to reskin
---@param options? SkinnerStyleOptions The style to apply
function SkinnerPrototype:Frame(frame, options) end

---Reskin the button with the specified style.
---@param button Button The button to reskin
---@param options? SkinnerStyleOptions The style to apply
function SkinnerPrototype:Button(button, options) end

---@class SkinnerMap
---@field ElvUI SkinnerPrototype
---@field WindTools SkinnerPrototype
---@field NDui SkinnerPrototype
M.Skinners = { None = SkinnerPrototype }

function M:OnInitialize()
	self:Debug("Skinner: OnInitialize")
	self:InitializeElvUISkinner()
	self:InitializeWindToolsSkinner()

	local skinnerID = E.db.global.general.skinner or "None"

	if skinnerID == "Auto" then
		if E.isElvUILoaded then
			skinnerID = "ElvUI"
			if E.isWindToolsLoaded then
				skinnerID = "WindTools"
			end
		elseif E.isNDuiLoaded then
			skinnerID = "NDui"
		else
			skinnerID = "None"
		end
	end

	Mixin(self, M.Skinners[skinnerID] or M.Skinners.None)

	self:Debug("Using skinner:", skinnerID)
end

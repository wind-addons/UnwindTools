local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Skinner") ---@class Skinner

function M:InitializeElvUISkinner()
	local ES = E.isElvUILoaded and F.Table.SafeGet("ElvUI", 1, "Skins")

	if not ES then
		return
	end

	local S = Mixin({}, M.Skinners.None)

	function S:Frame(frame, options)
		if frame.NineSlice then
			frame.NineSlice:Hide()
		end

		if options.template and options.createBackdrop and not frame.backdrop then
			frame:CreateBackdrop(frame, options.template)
			return
		end

		frame:SetTemplate(options.template)
	end

	function S:Button(button, options)
		ES:HandleButton(button, true, nil, options.createBackdrop, options.template)
	end

	self.Skinners.ElvUI = S
end

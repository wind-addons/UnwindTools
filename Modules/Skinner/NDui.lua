local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Skinner") ---@class Skinner

function M:InitializeNDuiSkinner()
	local B = E.isNDuiLoaded and F.Table.SafeGet("NDui", 1)
	if not B then
		return
	end

	local S = Mixin({}, M.Skinners.None)

	function S:Frame(frame, options)
		if frame.NineSlice then
			frame.NineSlice:Hide()
		end

		if options.template and options.createBackdrop and not frame.backdrop then
			frame.backdrop = B.CreateBDFrame(frame, options.template == "Default" and 1)
			if options.shadow then
				B.CreateSD(frame.backdrop)
			end
			return
		end

		B.CreateBD(frame, options.template == "Default" and 1)
		if options.shadow then
			B.CreateSD(frame)
		end
	end

	function S:Button(button, options)
		B.Reskin(button)
		if options.shadow then
			B.CreateSD(button)
		end
	end

	self.Skinners.NDui = S
end

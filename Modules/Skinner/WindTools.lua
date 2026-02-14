local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Skinner") ---@class Skinner

function M:InitializeWindToolsSkinner()
	local WS = E.isWindToolsLoaded and F.Table.SafeGet("WindTools", 1, "Modules", "Skins")

	if not WS then
		return
	end

	local S = Mixin({}, M.Skinners.None)

	function S:Frame(frame, options)
		M:Debug("WT Frame:", frame)
		M.Skinners.ElvUI:Frame(frame, options)

		if options and options.shadow then
			WS:CreateShadow(options.createBackdrop and frame.backdrop or frame)
		end
	end

	function S:Button(button, options)
		M:Debug("WT Button:", button)
		M.Skinners.ElvUI:Button(button, options)

		if options and options.shadow then
			WS:CreateShadow(options.createBackdrop and button.backdrop or button)
		end
	end

	self.Skinners.WindTools = S
end

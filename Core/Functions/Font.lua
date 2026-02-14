local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

local LSM = LibStub("LibSharedMedia-3.0")

---@class Functions.Font
F.Font = {}

F.Font.DefaultName = "Source Han Sans SC Bold"
F.Font.DefaultPath = LSM:Fetch(LSM.MediaType.FONT, F.Font.DefaultName)
F.Font.DefaultStyle = "OUTLINE" ---@type TBFFlags

---@class FontShadowOptions
---@field enabled boolean Whether to enable shadow
---@field offsetX? number Shadow offset in X direction
---@field offsetY? number Shadow offset in Y direction
---@field color? ColorInput Shadow color

---@class FontOptions
---@field file? string Font file path
---@field name? string Font name that registered in the LibSharedMedia-3.0
---@field style? TBFFlags|"NONE" Font style, e.g., "OUTLINE", "THICKOUTLINE"
---@field height? number Font height
---@field heightDiff? number Height difference to add to the current font height
---@field shadow? FontShadowOptions Shadow options

---Set font based on the given options
---@param fontString FontString The FontString to set the font for
---@param options FontOptions The font options
function F.Font.Set(fontString, options)
	assert(fontString, "FontString is required")
	assert(fontString.SetFont, "fontString parameter should be a FontString instance")
	assert(options, "Font options are required")

	local file = options.file or (options.name and LSM:Fetch(LSM.MediaType.FONT, options.name)) or F.Font.DefaultPath --[[@as FontFile]]
	local style = options.style or F.Font.DefaultStyle
	style = style == "NONE" and "" or style --[[@as TBFFlags]]
	local height = select(2, fontString:GetFont())
	height = options.heightDiff and (height + options.heightDiff) or options.height or height

	fontString:SetFont(file, height, style)

	if not options.shadow then
		return
	end

	if not options.shadow.enabled then
		fontString:SetShadowOffset(0, 0)
		return
	end

	local offsetX = options.shadow.offsetX or 1
	local offsetY = options.shadow.offsetY or -1
	fontString:SetShadowOffset(offsetX, offsetY)

	local color = options.shadow.color or "gray-500" ---@type ColorInput
	local rgba = F.Color.Parse(color)
	fontString:SetShadowColor(rgba:GetRGBA())
end

function F.Font.Outline(fontString)
	F.Font.Set(fontString, { style = "OUTLINE" })
end

local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

---@class Functions.Color
F.Color = {}

---@alias ColorInput ColorRGBData | ColorRGBAData | colorRGB | ColorMixin | ColorTemplate | string

---@alias ColorTemplate
---| "red-50"
---| "red-100"
---| "red-200"
---| "red-300"
---| "red-400"
---| "red-500"
---| "red-600"
---| "red-700"
---| "red-800"
---| "red-900"
---| "red-950"
---| "orange-50"
---| "orange-100"
---| "orange-200"
---| "orange-300"
---| "orange-400"
---| "orange-500"
---| "orange-600"
---| "orange-700"
---| "orange-800"
---| "orange-900"
---| "orange-950"
---| "amber-50"
---| "amber-100"
---| "amber-200"
---| "amber-300"
---| "amber-400"
---| "amber-500"
---| "amber-600"
---| "amber-700"
---| "amber-800"
---| "amber-900"
---| "amber-950"
---| "yellow-50"
---| "yellow-100"
---| "yellow-200"
---| "yellow-300"
---| "yellow-400"
---| "yellow-500"
---| "yellow-600"
---| "yellow-700"
---| "yellow-800"
---| "yellow-900"
---| "yellow-950"
---| "lime-50"
---| "lime-100"
---| "lime-200"
---| "lime-300"
---| "lime-400"
---| "lime-500"
---| "lime-600"
---| "lime-700"
---| "lime-800"
---| "lime-900"
---| "lime-950"
---| "green-50"
---| "green-100"
---| "green-200"
---| "green-300"
---| "green-400"
---| "green-500"
---| "green-600"
---| "green-700"
---| "green-800"
---| "green-900"
---| "green-950"
---| "emerald-50"
---| "emerald-100"
---| "emerald-200"
---| "emerald-300"
---| "emerald-400"
---| "emerald-500"
---| "emerald-600"
---| "emerald-700"
---| "emerald-800"
---| "emerald-900"
---| "emerald-950"
---| "teal-50"
---| "teal-100"
---| "teal-200"
---| "teal-300"
---| "teal-400"
---| "teal-500"
---| "teal-600"
---| "teal-700"
---| "teal-800"
---| "teal-900"
---| "teal-950"
---| "cyan-50"
---| "cyan-100"
---| "cyan-200"
---| "cyan-300"
---| "cyan-400"
---| "cyan-500"
---| "cyan-600"
---| "cyan-700"
---| "cyan-800"
---| "cyan-900"
---| "cyan-950"
---| "sky-50"
---| "sky-100"
---| "sky-200"
---| "sky-300"
---| "sky-400"
---| "sky-500"
---| "sky-600"
---| "sky-700"
---| "sky-800"
---| "sky-900"
---| "sky-950"
---| "blue-50"
---| "blue-100"
---| "blue-200"
---| "blue-300"
---| "blue-400"
---| "blue-500"
---| "blue-600"
---| "blue-700"
---| "blue-800"
---| "blue-900"
---| "blue-950"
---| "indigo-50"
---| "indigo-100"
---| "indigo-200"
---| "indigo-300"
---| "indigo-400"
---| "indigo-500"
---| "indigo-600"
---| "indigo-700"
---| "indigo-800"
---| "indigo-900"
---| "indigo-950"
---| "violet-50"
---| "violet-100"
---| "violet-200"
---| "violet-300"
---| "violet-400"
---| "violet-500"
---| "violet-600"
---| "violet-700"
---| "violet-800"
---| "violet-900"
---| "violet-950"
---| "purple-50"
---| "purple-100"
---| "purple-200"
---| "purple-300"
---| "purple-400"
---| "purple-500"
---| "purple-600"
---| "purple-700"
---| "purple-800"
---| "purple-900"
---| "purple-950"
---| "fuchsia-50"
---| "fuchsia-100"
---| "fuchsia-200"
---| "fuchsia-300"
---| "fuchsia-400"
---| "fuchsia-500"
---| "fuchsia-600"
---| "fuchsia-700"
---| "fuchsia-800"
---| "fuchsia-900"
---| "fuchsia-950"
---| "pink-50"
---| "pink-100"
---| "pink-200"
---| "pink-300"
---| "pink-400"
---| "pink-500"
---| "pink-600"
---| "pink-700"
---| "pink-800"
---| "pink-900"
---| "pink-950"
---| "rose-50"
---| "rose-100"
---| "rose-200"
---| "rose-300"
---| "rose-400"
---| "rose-500"
---| "rose-600"
---| "rose-700"
---| "rose-800"
---| "rose-900"
---| "rose-950"
---| "slate-50"
---| "slate-100"
---| "slate-200"
---| "slate-300"
---| "slate-400"
---| "slate-500"
---| "slate-600"
---| "slate-700"
---| "slate-800"
---| "slate-900"
---| "slate-950"
---| "gray-50"
---| "gray-100"
---| "gray-200"
---| "gray-300"
---| "gray-400"
---| "gray-500"
---| "gray-600"
---| "gray-700"
---| "gray-800"
---| "gray-900"
---| "gray-950"
---| "zinc-50"
---| "zinc-100"
---| "zinc-200"
---| "zinc-300"
---| "zinc-400"
---| "zinc-500"
---| "zinc-600"
---| "zinc-700"
---| "zinc-800"
---| "zinc-900"
---| "zinc-950"
---| "neutral-50"
---| "neutral-100"
---| "neutral-200"
---| "neutral-300"
---| "neutral-400"
---| "neutral-500"
---| "neutral-600"
---| "neutral-700"
---| "neutral-800"
---| "neutral-900"
---| "neutral-950"
---| "stone-50"
---| "stone-100"
---| "stone-200"
---| "stone-300"
---| "stone-400"
---| "stone-500"
---| "stone-600"
---| "stone-700"
---| "stone-800"
---| "stone-900"
---| "stone-950"
---| "warm-gray-50"

---Tailwind Colors v4.1 https://tailwindcss.com/docs/colors
---Convert Script: https://github.com/wind-addons/WindToolsScripts/blob/master/CSSToRGB
---@type table<ColorTemplate, string>
local TailwindColorTemplates = {
	["red-50"] = "fef2f2",
	["red-100"] = "fee1e1",
	["red-200"] = "ffc8c8",
	["red-300"] = "ffa0a0",
	["red-400"] = "ff6366",
	["red-500"] = "fa2f39",
	["red-600"] = "e60012",
	["red-700"] = "bf000f",
	["red-800"] = "9d0f18",
	["red-900"] = "801d1f",
	["red-950"] = "471011",
	["orange-50"] = "fff6ec",
	["orange-100"] = "ffecd3",
	["orange-200"] = "ffd5a6",
	["orange-300"] = "ffb669",
	["orange-400"] = "ff870b",
	["orange-500"] = "ff6800",
	["orange-600"] = "f44a00",
	["orange-700"] = "c83700",
	["orange-800"] = "9d3000",
	["orange-900"] = "7d2e13",
	["orange-950"] = "45190e",
	["amber-50"] = "fffae9",
	["amber-100"] = "fef2c4",
	["amber-200"] = "fde584",
	["amber-300"] = "ffd033",
	["amber-400"] = "ffb800",
	["amber-500"] = "fd9800",
	["amber-600"] = "e07000",
	["amber-700"] = "b94d00",
	["amber-800"] = "953e00",
	["amber-900"] = "79360e",
	["amber-950"] = "471f06",
	["yellow-50"] = "fdfbe7",
	["yellow-100"] = "fef8c0",
	["yellow-200"] = "feef84",
	["yellow-300"] = "ffde25",
	["yellow-400"] = "fdc600",
	["yellow-500"] = "efaf00",
	["yellow-600"] = "cf8500",
	["yellow-700"] = "a45f00",
	["yellow-800"] = "874b00",
	["yellow-900"] = "724012",
	["yellow-950"] = "44240c",
	["lime-50"] = "f6fee6",
	["lime-100"] = "ebfcc9",
	["lime-200"] = "d7f997",
	["lime-300"] = "b9f351",
	["lime-400"] = "98e500",
	["lime-500"] = "7bcd00",
	["lime-600"] = "5ea300",
	["lime-700"] = "4a7c00",
	["lime-800"] = "3e6200",
	["lime-900"] = "375415",
	["lime-950"] = "1f310a",
	["green-50"] = "effcf3",
	["green-100"] = "dafbe5",
	["green-200"] = "b7f7cd",
	["green-300"] = "79f0a6",
	["green-400"] = "0dde71",
	["green-500"] = "00c751",
	["green-600"] = "00a43f",
	["green-700"] = "008138",
	["green-800"] = "076633",
	["green-900"] = "14542f",
	["green-950"] = "0a311b",
	["emerald-50"] = "ebfcf4",
	["emerald-100"] = "cef9e3",
	["emerald-200"] = "a2f3ce",
	["emerald-300"] = "5ee8b3",
	["emerald-400"] = "00d390",
	["emerald-500"] = "00ba7b",
	["emerald-600"] = "009765",
	["emerald-700"] = "007955",
	["emerald-800"] = "006046",
	["emerald-900"] = "004f3d",
	["emerald-950"] = "003026",
	["teal-50"] = "effdf9",
	["teal-100"] = "c9fbf0",
	["teal-200"] = "94f6e3",
	["teal-300"] = "47ebd3",
	["teal-400"] = "00d3bc",
	["teal-500"] = "00b9a5",
	["teal-600"] = "009487",
	["teal-700"] = "00766e",
	["teal-800"] = "005f5a",
	["teal-900"] = "124f4b",
	["teal-950"] = "083231",
	["cyan-50"] = "ebfdfe",
	["cyan-100"] = "cdf9fe",
	["cyan-200"] = "a0f3fc",
	["cyan-300"] = "54e9fc",
	["cyan-400"] = "00d1f2",
	["cyan-500"] = "00b6d9",
	["cyan-600"] = "0091b6",
	["cyan-700"] = "007493",
	["cyan-800"] = "005e77",
	["cyan-900"] = "174f64",
	["cyan-950"] = "0d3646",
	["sky-50"] = "eff8ff",
	["sky-100"] = "def1fe",
	["sky-200"] = "b6e5fe",
	["sky-300"] = "72d2ff",
	["sky-400"] = "00baff",
	["sky-500"] = "00a4f3",
	["sky-600"] = "0083cf",
	["sky-700"] = "0068a6",
	["sky-800"] = "005988",
	["sky-900"] = "084b6f",
	["sky-950"] = "0d324b",
	["blue-50"] = "eef5fe",
	["blue-100"] = "d9e9fe",
	["blue-200"] = "bcd9ff",
	["blue-300"] = "8cc3ff",
	["blue-400"] = "51a0ff",
	["blue-500"] = "2f7eff",
	["blue-600"] = "1b5dfb",
	["blue-700"] = "1a48e5",
	["blue-800"] = "1f3eb6",
	["blue-900"] = "213b8c",
	["blue-950"] = "1c2956",
	["indigo-50"] = "edf1ff",
	["indigo-100"] = "dfe6ff",
	["indigo-200"] = "c5d0ff",
	["indigo-300"] = "a1b1ff",
	["indigo-400"] = "7b85ff",
	["indigo-500"] = "615fff",
	["indigo-600"] = "503bf6",
	["indigo-700"] = "4530d6",
	["indigo-800"] = "392daa",
	["indigo-900"] = "342f84",
	["indigo-950"] = "23204d",
	["violet-50"] = "f4f2fe",
	["violet-100"] = "ece8fe",
	["violet-200"] = "dcd4ff",
	["violet-300"] = "c3b2ff",
	["violet-400"] = "a482ff",
	["violet-500"] = "8c52ff",
	["violet-600"] = "7e27fd",
	["violet-700"] = "6f10e6",
	["violet-800"] = "5d15be",
	["violet-900"] = "4e1d98",
	["violet-950"] = "321467",
	["purple-50"] = "f9f4fe",
	["purple-100"] = "f2e7fe",
	["purple-200"] = "e8d3ff",
	["purple-300"] = "d8b0ff",
	["purple-400"] = "c079ff",
	["purple-500"] = "ab47ff",
	["purple-600"] = "9617fa",
	["purple-700"] = "8100d9",
	["purple-800"] = "6d18ae",
	["purple-900"] = "591c89",
	["purple-950"] = "3e0a66",
	["fuchsia-50"] = "fcf3fe",
	["fuchsia-100"] = "fae7ff",
	["fuchsia-200"] = "f5ceff",
	["fuchsia-300"] = "f3a6ff",
	["fuchsia-400"] = "ec6aff",
	["fuchsia-500"] = "e02efa",
	["fuchsia-600"] = "c600dd",
	["fuchsia-700"] = "a600b5",
	["fuchsia-800"] = "880793",
	["fuchsia-900"] = "711a76",
	["fuchsia-950"] = "4c0450",
	["pink-50"] = "fcf1f7",
	["pink-100"] = "fce6f2",
	["pink-200"] = "fbcde7",
	["pink-300"] = "fda3d4",
	["pink-400"] = "fb63b4",
	["pink-500"] = "f53598",
	["pink-600"] = "e50075",
	["pink-700"] = "c5005b",
	["pink-800"] = "a1004d",
	["pink-900"] = "841744",
	["pink-950"] = "520b28",
	["rose-50"] = "fef0f1",
	["rose-100"] = "ffe3e5",
	["rose-200"] = "ffcbd1",
	["rose-300"] = "ff9fab",
	["rose-400"] = "ff637d",
	["rose-500"] = "ff2457",
	["rose-600"] = "eb0041",
	["rose-700"] = "c50038",
	["rose-800"] = "a30038",
	["rose-900"] = "891038",
	["rose-950"] = "4e091e",
	["slate-50"] = "f7f9fb",
	["slate-100"] = "f0f4f8",
	["slate-200"] = "e1e7ef",
	["slate-300"] = "c8d4e1",
	["slate-400"] = "8e9fb7",
	["slate-500"] = "61738c",
	["slate-600"] = "46556b",
	["slate-700"] = "344358",
	["slate-800"] = "222c3f",
	["slate-900"] = "161d2e",
	["slate-950"] = "080e1d",
	["gray-50"] = "f8f9fb",
	["gray-100"] = "f2f3f5",
	["gray-200"] = "e4e6ea",
	["gray-300"] = "cfd4da",
	["gray-400"] = "979fad",
	["gray-500"] = "697181",
	["gray-600"] = "4b5564",
	["gray-700"] = "384353",
	["gray-800"] = "232d3b",
	["gray-900"] = "171e2c",
	["gray-950"] = "0a0f19",
	["zinc-50"] = "f9f9f9",
	["zinc-100"] = "f3f3f4",
	["zinc-200"] = "e3e3e6",
	["zinc-300"] = "d2d2d7",
	["zinc-400"] = "9d9da7",
	["zinc-500"] = "70707a",
	["zinc-600"] = "52525c",
	["zinc-700"] = "414148",
	["zinc-800"] = "2b2b2e",
	["zinc-900"] = "1e1e20",
	["zinc-950"] = "111113",
	["neutral-50"] = "f9f9f9",
	["neutral-100"] = "f4f4f4",
	["neutral-200"] = "e4e4e4",
	["neutral-300"] = "d2d2d2",
	["neutral-400"] = "9f9f9f",
	["neutral-500"] = "727272",
	["neutral-600"] = "525252",
	["neutral-700"] = "414141",
	["neutral-800"] = "2a2a2a",
	["neutral-900"] = "1d1d1d",
	["neutral-950"] = "121212",
	["stone-50"] = "f9f9f9",
	["stone-100"] = "f4f4f3",
	["stone-200"] = "e6e4e2",
	["stone-300"] = "d5d1cf",
	["stone-400"] = "a49e99",
	["stone-500"] = "77706a",
	["stone-600"] = "57534e",
	["stone-700"] = "46413d",
	["stone-800"] = "2d2928",
	["stone-900"] = "211f1d",
	["stone-950"] = "131211",
}

local function IsUnderFF(n)
	return type(n) == "number" and n >= 0 and n <= 255
end

---Validate that a value is a valid RGBColor table
---@param value any The value to validate
---@return boolean isValid Whether the value is a valid RGBColor
function F.Color.IsValidColor(value)
	if type(value) == "table" then
		return IsUnderFF(value.r) and IsUnderFF(value.g) and IsUnderFF(value.b)
	elseif type(value) == "string" then
		if TailwindColorTemplates[value] then
			return true
		end

		local hex = string.match(value, "^#?([0-9a-fA-F]+)$")
		return hex and (#hex == 3 or #hex == 6)
	end

	return false
end

---Parse a color input into RGBA data
---@param color ColorInput The color to parse
---@return ColorMixin color RGBA color with ColorMixin methods
function F.Color.Parse(color)
	if type(color) == "table" then
		if color.GetRGB then
			return color --[[@as ColorMixin]]
		elseif color.r and color.g and color.b then
			local r, g, b, a = color.r, color.g, color.b, color.a or 1
			if r <= 1 and g <= 1 and b <= 1 then
				return CreateColor(r, g, b, a)
			else
				return CreateColorFromBytes(r, g, b, a * 255)
			end
		elseif color[1] and color[2] and color[3] then
			local r, g, b, a = color[1], color[2], color[3], color[4] or 1
			if r <= 1 and g <= 1 and b <= 1 then
				return CreateColor(r, g, b, a)
			else
				return CreateColorFromBytes(r, g, b, a * 255)
			end
		end
	elseif type(color) == "string" then
		local hex = TailwindColorTemplates[color] or color
		local rgba = F.Color.HexToRGB(hex)
		return CreateColorFromBytes(rgba.r, rgba.g, rgba.b, rgba.a)
	end

	error("Invalid color input: expected RGB/RGBA table, ColorMixin, ColorTemplate, or Hex string")
end

---Convert hex color code to RGB/RGBA color table
---@param hex string Hex color code (supports 3/6/8 digits, with or without # prefix)
---@return ColorRGBAData rgba RGBA color table with r, g, b, a components (0-255, 0-255)
function F.Color.HexToRGB(hex)
	assert(type(hex) == "string", "Hex must be a string, got " .. type(hex))

	if string.byte(hex, 1) == 35 then
		hex = string.sub(hex, 2)
	end

	if #hex == 3 then
		hex = string.gsub(hex, ".", "%1%1")
	end

	assert(#hex == 6 or #hex == 8, "Hex must be a valid 3, 6 or 8-character hex code, got length " .. #hex)

	local r, g, b, a
	if #hex == 8 then
		a = tonumber(string.sub(hex, 1, 2), 16)
		r = tonumber(string.sub(hex, 3, 4), 16)
		g = tonumber(string.sub(hex, 5, 6), 16)
		b = tonumber(string.sub(hex, 7, 8), 16)
	else
		r = tonumber(string.sub(hex, 1, 2), 16)
		g = tonumber(string.sub(hex, 3, 4), 16)
		b = tonumber(string.sub(hex, 5, 6), 16)
		a = 255
	end

	assert(r and g and b and a, "Failed to parse hex color values")

	return { r = r, g = g, b = b, a = a }
end

---Create colored string with support for one or multiple colors
---If only one color is provided, it will color the entire string.
---If multiple colors are provided, it will color the string in segments from left to right in gradient style.
---@param text string The text to colorize
---@param ... ColorInput One or more colors (Hex, Template, or RGB Table)
---@return string coloredText The colored string
function F.Color.String(text, ...)
	assert(type(text) == "string", "Text must be a string, got " .. type(text))

	local numArgs = select("#", ...)
	if text == "" or numArgs == 0 then
		return text
	end

	local colors = {}
	for i = 1, numArgs do
		table.insert(colors, F.Color.Parse(select(i, ...)))
	end

	if #colors == 1 then
		return colors[1]:WrapTextInColorCode(text)
	end

	local length = string.utf8len(text)
	if length == 0 then
		return text
	end
	if length == 1 then
		return colors[1]:WrapTextInColorCode(text)
	end

	local result = {}
	local numColors = #colors
	local step = 1 / (length - 1)

	for i = 1, length do
		local char = string.utf8sub(text, i, i)
		local t = (i - 1) * step

		local colorIndex = math.floor(t * (numColors - 1)) + 1
		if colorIndex >= numColors then
			colorIndex = numColors - 1
		end

		local startT = (colorIndex - 1) / (numColors - 1)
		local endT = colorIndex / (numColors - 1)
		local segmentT = (t - startT) / (endT - startT)

		local startColor = colors[colorIndex]
		local stopColor = colors[colorIndex + 1]

		local sr, sg, sb = startColor:GetRGB()
		local er, eg, eb = stopColor:GetRGB()
		local midColor = CreateColor(sr + (er - sr) * segmentT, sg + (eg - sg) * segmentT, sb + (eb - sb) * segmentT)

		tAppendAll(result, { midColor:GenerateHexColorMarkup(), char, "|r" })
	end

	return table.concat(result)
end

do
	---@type ColorRGBData[]
	local WindStyleColors = {
		{ r = 84, g = 133, b = 237 },
		{ r = 74, g = 181, b = 228 },
		{ r = 66, g = 215, b = 221 },
	}

	---Create a Wind style colored string
	---@param text string The text to colorize
	---@return string coloredText The colored string
	function F.Color.StringInWindStyle(text)
		return F.Color.String(text, unpack(WindStyleColors))
	end
end

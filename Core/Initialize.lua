local name, addon = ...

---@class Engine: AceAddon, AceEvent-3.0
---@class Functions
---@alias Localization table<string, string>

_G[name] = addon

---@class Functions
local F = {
	SaveVariables = _G[name .. "DB"] --[[@as table]],
}

---@alias Namespace [Engine, Functions, Localization]
addon[1] = LibStub("AceAddon-3.0"):NewAddon(name)
addon[2] = F
addon[3] = LibStub("AceLocale-3.0"):GetLocale(name, true)

wind.restoreLocale()

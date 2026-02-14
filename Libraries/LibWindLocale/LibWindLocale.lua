local name = ...

local LOCALE_PATH = name.."DB.global.general.locale"

local function safeGet(t, ...)
    for _, key in ipairs({...}) do
        t = t and t[key]
    end
    return t
end

local BEFORE_GAME_LOCALE = GAME_LOCALE
GAME_LOCALE = safeGet(_G, string.split("%.", LOCALE_PATH)) or GetLocale()

local function RestoreLocale()
    GAME_LOCALE = BEFORE_GAME_LOCALE
end

local wind = wind or {}
wind.restoreLocale = RestoreLocale

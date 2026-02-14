local addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

local directory = ([[Interface\Addons\%s\Media\]]):format(addon)

local languageMask = LSM["LOCALE_BIT_" .. GetLocale()] or LSM.LOCALE_BIT_western

LSM:Register("font", "Source Han Sans SC Bold", directory .. [[Fonts\Source Han Sans SC Bold.otf]], languageMask)

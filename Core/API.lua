local ns = select(2, ...) ---@type Namespace
local E = ns[1] ---@class Engine
local F = ns[2]
local L = ns[3]

E.Delay = F.Async.Delay
E.Dump = F.Logger.Dump
E.Inspect = F.Logger.Inspect

function E:Debug(...)
	if (self.db and self.db.global.general.logLevel or F.Logger.ConfiguredLevel) ~= "DEBUG" then
		return
	end

	if select("#", ...) == 0 then
		F.Logger.Debug("No arguments provided to debug")
		return
	end

	if type(select(1, ...)) == "function" then
		local status, result = pcall(...)
		if not status then
			F.Logger.Debug("Error executing debug function:", result)
		elseif result ~= nil then
			E:Debug(result)
		end
	else
		F.Logger.Debug(...)
	end
end

--- @class WindModule: AceModule, AceEvent-3.0, AceHook-3.0, Defaults
local ModulePrototype = {}

---Log a message with the specified log level
ModulePrototype.Log = F.Logger.LogWithModule

---Print a debug message to chat frame
---@param ...any The elements to print
function ModulePrototype:Debug(...)
	F.Logger.LogWithModule(self, "DEBUG", ...)
end

---Sets the category of the module
---@param category string The category of the module
---@return WindModule
function ModulePrototype:SetCategory(category)
	self.__category = category

	return self
end

---Sets the unique ID of the module
---@param id string The unique ID of the module
---@return WindModule
function ModulePrototype:SetID(id)
	self.__id = id

	return self
end

---Sets the title of the module
---@param title string The title of the module, which have been localized
---@return WindModule
function ModulePrototype:SetTitle(title)
	self.__title = title

	return self
end

---Adds default settings for the module to the addon's database.
---@param defaults Defaults The default settings for the module
---@return WindModule
function ModulePrototype:SetDefaults(defaults)
	assert(type(self.__id) == "string", "Module ID is not set for module: " .. tostring(self.moduleName))

	E.AddDefaults(self.__id, defaults)

	return self
end

---Adds a new settings group to the addon's configuration panel.
---@param settings table The settings table to add
---@return WindModule
function ModulePrototype:SetSettings(settings)
	assert(type(self.__id) == "string", "Module ID is not set for module: " .. tostring(self.moduleName))
	assert(type(self.__category) == "string", "Module category is not set for module: " .. tostring(self.moduleName))
	assert(type(self.__title) == "string", "Module title is not set for module: " .. tostring(self.moduleName))

	E:AddSettings(self.__category, self:GetName(), self.__id, self.__title, settings)

	return self
end

E:SetDefaultModuleLibraries("AceEvent-3.0", "AceHook-3.0")
E:SetDefaultModulePrototype(ModulePrototype)

---@param name string Unique name of the Module
---@return WindModule module
function E:Module(name)
	local module = self:GetModule(name, true)
	if not module then
		module = self:NewModule(name)
	end
	return module --[[@as WindModule]]
end

---@alias StaticPopupDialogKey
---| "SettingRefreshReload"

---@type table<StaticPopupDialogKey, {id: StaticPopupDialogKey, info: table}>
E.Dialogs = {}

E.Dialogs.SettingRefreshReload = {
	id = E.name .. "_SETTING_REFRESH_RELOAD",
	info = {
		title = E.title,
		text = L["You need to reload your UI to apply the settings changes. Do you want to reload now?"],
		button1 = F.Color.String(L["Yes"], "amber-500"),
		button2 = F.Color.String(L["No"], "gray-300"),
		OnAccept = C_UI.Reload,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	},
}

-- Register all dialogs
TableUtil.Execute(E.Dialogs, function(data)
	StaticPopupDialogs[data.id] = data.info
end)

---Shows a dialog by its name
---@param dialogName StaticPopupDialogKey|string The unique name of the dialog to show
---@param ... any Arguments to pass to StaticPopup_Show
---@return Frame? The dialog frame shown
function E:ShowDialog(dialogName, ...)
	assert(type(dialogName) == "string", "Dialog name must be a string, got " .. type(dialogName))

	dialogName = E.Dialogs[dialogName] and E.Dialogs[dialogName].id or dialogName

	return StaticPopup_Show(dialogName, ...) --[[@as Frame?]]
end

---@alias CallbackFunction fun(ctx, ...: any)

---@type table<string, CallbackFunction[]>
E.Callbacks = {}

---Fires a callback event
---@param message string The message to fire
---@param ... any Arguments to pass to the callback functions
---@return any The result of the last callback function executed
function E:Callback(message, ...)
	if not self.Callbacks[message] then
		E:Debug("No callbacks registered for message:", message)
		return
	end

	local result, ctx = nil, {}
	for _, func in ipairs(self.Callbacks[message]) do
		result = func(ctx, ...)
	end

	return result
end

---Registers a callback function for a specific message
---@param message string The message to register for
---@param func CallbackFunction The callback function to register
function E:RegisterCallback(message, func)
	assert(type(message) == "string", "Message must be a string, got " .. type(message))
	assert(type(func) == "function", "Callback must be a function, got " .. type(func))

	if not self.Callbacks[message] then
		self.Callbacks[message] = {}
	end

	table.insert(self.Callbacks[message], func)
end

---Generates a macro line to trigger a callback
---@param message string The message to trigger
---@return string The macro line
function E:GetCallbackMacroLine(message)
	return string.format("/run UnwindTools[1]:Callback('%s')", message)
end

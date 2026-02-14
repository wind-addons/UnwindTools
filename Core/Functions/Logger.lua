local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

--- @class Functions.Logger
F.Logger = {}

---@alias LogLevel "DEBUG" | "INFO" | "WARN" | "ERROR"

---@class LogLevelData
---@field severity number Severity level (higher = more severe)
---@field prefix string Colored prefix for the log level

---@type table<LogLevel, LogLevelData>
F.Logger.Levels = {
	DEBUG = { severity = 1, prefix = F.Color.String("[DBG]", "emerald-600", "emerald-300") },
	INFO = { severity = 2, prefix = F.Color.String("[INF]", "blue-600", "blue-300") },
	WARN = { severity = 3, prefix = F.Color.String("[WRN]", "amber-600", "amber-300") },
	ERROR = { severity = 4, prefix = F.Color.String("[ERR]", "rose-600", "rose-300") },
}

local minimumSeverity = 4

F.Logger.ConfiguredLevel = F.Table.SafeGet(F, "SaveVariables", "global", "general", "logLevel")
if F.Logger.ConfiguredLevel and F.Logger.Levels[F.Logger.ConfiguredLevel] then
	minimumSeverity = F.Logger.Levels[F.Logger.ConfiguredLevel].severity
else
	F.Logger.ConfiguredLevel = "ERROR"
end

---Sets the minimum log level. Messages with a lower level will be ignored.
---@param level LogLevel The minimum log level
F.Logger.SetMinimumLogLevel = function(level)
	assert(type(level) == "string", "Level must be a string, got " .. type(level))

	local levelInfo = F.Logger.Levels[level]
	assert(levelInfo ~= nil, "Log level not found: " .. tostring(level))

	minimumSeverity = levelInfo.severity
end

---Log a message with the specified level
---@param level LogLevel Log level (DEBUG, INFO, WARN, or ERROR)
---@param ...any The elements to log
function F.Logger.Log(level, ...)
	assert(type(level) == "string", "Level must be a string, got " .. type(level))

	local levelInfo = F.Logger.Levels[level]
	assert(levelInfo ~= nil, "Log level not found: " .. tostring(level))

	if levelInfo.severity < minimumSeverity then
		return
	end

	local args = { ... }

	assert(#args > 0, "At least one argument is required to log")

	for i = 1, #args do
		local t = type(args[i])
		if t == "nil" then
			args[i] = "nil"
		elseif t == "string" then
			-- do nothing
		elseif t == "table" then
			if args[i].GetDebugName == "function" then
				args[i] = args[i]:GetDebugName()
				print(args[i])
			elseif t == "table" and type(args[i].GetName) == "function" then
				args[i] = args[i]:GetName()
				if args[i] == nil then
					args[i] = F.Table.Inspect(args[i])
				end
			else
				args[i] = F.Table.Inspect(args[i])
			end
		else
			args[i] = tostring(args[i])
		end
	end

	local message = table.concat(args, " ")

	message = levelInfo.prefix .. " " .. message

	DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1)
end

---Log a debug message
---@param ...any The elements to log
function F.Logger.Debug(...)
	return F.Logger.Log("DEBUG", ...)
end

---Log an info message
---@param ...any The elements to log
function F.Logger.Info(...)
	F.Logger.Log("INFO", ...)
end

---Log a warning message
---@param ...any The elements to log
function F.Logger.Warn(...)
	F.Logger.Log("WARN", ...)
end

---Log an error message
---@param ...any The elements to log
function F.Logger.Error(...)
	F.Logger.Log("ERROR", ...)
end

---Log a message for a specific module with the specified level
---@param module WindModule The module to log the message for
---@param level LogLevel Log level (DEBUG, INFO, WARN, or ERROR)
---@param ...any The elements to log
function F.Logger.LogWithModule(module, level, ...)
	assert(type(module) == "table", "Module must be a table, got " .. type(module))

	local name = module.__title or module.GetName and module:GetName()
	assert(type(name) == "string", "Module name must be a string, got " .. type(name))

	local moduleTag = F.Color.String(string.format("[%s]", name), "rose-400", "amber-500")

	F.Logger.Log(level, moduleTag, ...)
end

---Inspect object with DevTool addon
---https://github.com/brittyazel/DevTool
---@param obj any Object to inspect
---@param objName string? Name for the object (optional)
function F.Logger.SendToDevTool(obj, objName)
	if DevTool and DevTool.AddData then
		DevTool:AddData(obj, objName)
	end
end

---Dump object
---@param obj any Object to dump
---@param objName string? Name for the object (optional)
function F.Logger.Dump(obj, objName)
	F.Logger.SendToDevTool(obj, objName)
	DevTools_Dump(obj)
end

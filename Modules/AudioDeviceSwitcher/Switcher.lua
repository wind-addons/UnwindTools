local ns = select(2, ...) ---@type Namespace
local E, F, L = ns[1], ns[2], ns[3]

local M = E:Module("Audio Device Switcher") ---@class AudioDeviceSwitcher: WindModule

---@class AudioDeviceSwitcherDeviceInfo
---@field cvarIndex number
---@field displayName string
---@field systemName string

---@return table<number, string>
function M:GetAllDeviceNames()
	local devices = {}
	local count = Sound_GameSystem_GetNumOutputDrivers()

	for index = 1, count do
		local name = Sound_GameSystem_GetOutputDriverNameByIndex(index)
		if F.Validator.IsNonEmptyString(name) then
			devices[index] = name
		end
	end

	return devices
end

---@return AudioDeviceSwitcherDeviceInfo[]
function M:GetConfiguredDevices()
	local allDevices = self:GetAllDeviceNames()

	local configured = {}
	local usedDriverIndices = {}

	for index = 1, 5 do
		local db = self.profile["device" .. index]
		if
			db
			and db.enable
			and F.Validator.IsNonEmptyString(db.pattern)
			and F.Validator.IsNonEmptyString(db.displayName)
		then
			for driverIndex, deviceName in pairs(allDevices) do
				local isMatched = string.find(string.lower(deviceName), string.lower(db.pattern), 1, true)
				if isMatched and not usedDriverIndices[driverIndex] then
					usedDriverIndices[driverIndex] = true
					table.insert(configured, {
						cvarIndex = driverIndex,
						displayName = db.displayName,
						systemName = deviceName,
					})
					break
				end
			end
		end
	end

	return configured
end

---@return number?
function M:GetCurrentDriverIndex()
	return tonumber(C_CVar.GetCVar("Sound_OutputDriverIndex"))
end

---@return string
function M:GetCurrentDeviceName()
	local currentDriverIndex = self:GetCurrentDriverIndex()
	if not currentDriverIndex then
		return L["Other"]
	end

	for _, info in ipairs(self:GetConfiguredDevices()) do
		if info.cvarIndex == currentDriverIndex then
			return info.displayName
		end
	end

	return L["Other"]
end

function M:SwitchDevice()
	local devices = self:GetConfiguredDevices()
	if #devices <= 1 then
		self:UpdateButtonVisibility()
		self:UpdateButtonText()
		return
	end

	local currentDriverIndex = self:GetCurrentDriverIndex()
	if not currentDriverIndex then
		self:Log("ERROR", "Failed to get current sound output driver index.")
		return
	end

	local currentConfigIndex = 0
	for index, info in ipairs(devices) do
		if info.cvarIndex == currentDriverIndex then
			currentConfigIndex = index
			break
		end
	end

	local nextConfigIndex = currentConfigIndex % #devices + 1
	C_CVar.SetCVar("Sound_OutputDriverIndex", devices[nextConfigIndex].cvarIndex)
end
local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

---@class Functions.Mover
F.Mover = {}

---@alias MoverSavedID string

---@class PointData
---@field point string
---@field relativeTo string
---@field relativePoint string
---@field x number
---@field y number

---@alias MovableObject Frame | Button

---@class MoverConfig
---@field id MoverSavedID
---@field target MovableObject

---@type table<MovableObject, MoverConfig>
F.Mover.Configs = {}

---@type table<MoverSavedID, PointData>
F.Mover.States = {}

---Resets all saved mover states.
function F.Mover.ResetAll()
	F.Mover.States = {}
end

---Sets the database table to use for storing mover states.
---@param db table<MoverSavedID, PointData> the database table
function F.Mover.SetStatesDB(db)
	assert(type(db) == "table", "db must be a table")
	F.Mover.States = db
end

---Gets all anchor points from the given frame.
---@param frame MovableObject the frame to grab points from
---@return PointData[] the saved points
function F.Mover.GetAllPoints(frame)
	assert(frame and frame.GetNumPoints and frame.GetPoint, "frame must be a valid Frame")

	local states = {} ---@type PointData[]
	local numPoints = frame:GetNumPoints()
	if numPoints == 0 then
		return states
	end

	for i = 1, numPoints do
		local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
		local relativeToName = relativeTo and (relativeTo.GetName and relativeTo:GetName()) or "UIParent"
		states[i] = { point = point, relativeTo = relativeToName, relativePoint = relativePoint, x = x, y = y }
	end

	return states
end

---Grabs first anchor points from the given frame.
---@param frame MovableObject the frame to grab points from
---@return PointData? the saved points
function F.Mover.GetFirstPoint(frame)
	assert(frame and frame.GetNumPoints and frame.GetPoint, "frame must be a valid Frame")

	local numPoints = frame:GetNumPoints()
	if numPoints == 0 then
		return nil
	end

	local point, relativeTo, relativePoint, x, y = frame:GetPoint(1)
	local relativeToName = relativeTo and (relativeTo.GetName and relativeTo:GetName()) or "UIParent"
	return { point = point, relativeTo = relativeToName, relativePoint = relativePoint, x = x, y = y }
end

local function ValidateState(state)
	---@cast state PointData
	local missing = not _G[state.relativeTo] or not _G[state.relativeTo].IsObjectType
	if missing then
		F.Logger.Debug("Frame", state.relativeTo, "is missing in UIParent")
	end
	return not missing
end

---The handler for when the drag starts.
---@param self MovableObject the frame being dragged
local function OnDragStart(self)
	local config = F.Mover.Configs[self]
	if not config then
		F.Logger.Error("Cannot start moving frame, no config found. Frame:", self)
	end

	config.target:StartMoving()
end

---The handler for when the drag stops.
---@param self MovableObject the frame being dragged
local function OnDragStop(self)
	local config = F.Mover.Configs[self]
	if not config then
		F.Logger.Error("Cannot stop moving frame, no config found. Frame:", self)
	end

	config.target:StopMovingOrSizing()

	F.Mover.States[config.id] = F.Mover.GetFirstPoint(config.target)
end

---Set the frame to be movable, and create the auto save.
---@param frame Frame | Button the frame to make movable
---@param options { id: string, target?: string | MovableObject }
function F.Mover.New(frame, options)
	assert(type(options) == "table", "options must be a table")

	local target = frame

	if options.target then
		target = type(options.target) ~= "string" and options.target --[[@as MovableObject?]]
			or _G[options.target]
		assert(
			target and type(target) == "table" and target.SetMovable,
			"options.target must be a valid Frame or the name of a Frame"
		)
	end

	F.Mover.Configs[frame] = { id = options.id, target = target }

	target:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)
end

---Restores the frame to its saved position.
---@param frame MovableObject the frame to restore
function F.Mover.Restore(frame)
	local config = F.Mover.Configs[frame]
	if not config then
		F.Logger.Debug("No config found for frame:", frame)
		return
	end

	local state = F.Mover.States[config.id]
	if not state or not ValidateState(state) then
		F.Logger.Debug("No valid saved state found for frame:", frame, state)
		return
	end

	frame:ClearAllPoints()
	frame:SetPoint(state.point, _G[state.relativeTo], state.relativePoint, state.x, state.y)
end

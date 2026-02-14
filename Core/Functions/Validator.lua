local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

---@class Functions.Validator
F.Validator = {}

---Check if the value is a non-empty string
---@param value any The value to check
---@return boolean True if the value is a non-empty string, false otherwise
function F.Validator.IsNonEmptyString(value)
	return not issecretvalue(value) and type(value) == "string" and value ~= ""
end

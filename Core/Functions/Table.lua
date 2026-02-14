local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

---@class Funtions.Table
F.Table = {}

---@type table<string, string>
F.Table.Actions = {
	RemoveField = "__TABLE_ACTION_REMOVE_FIELD__",
}

---Merges the contents of the source table into the destination table recursively.
---@param dest table The destination table to merge into
---@param ...table The source tables to merge from, the merges are applied in order
function F.Table.DeepExtend(dest, ...)
	assert(type(dest) == "table", "dest must be a table")

	for i = 1, select("#", ...) do
		local src = select(i, ...)
		assert(type(src) == "table", "src (arg #" .. i + 1 .. ") must be a table")

		for key, value in pairs(src) do
			if value == F.Table.Actions.RemoveField then
				dest[key] = nil
			elseif type(value) == "table" then
				dest[key] = F.Table.DeepExtend(type(dest[key]) == "table" and dest[key] or {}, value)
			else
				dest[key] = value
			end
		end
	end

	return dest
end

---Inspects a table and returns a string representation.
---@param tbl table The table to inspect.
---@return string
function F.Table.Inspect(tbl)
	return wind.inspect(tbl)
end

---Safely retrieves a value from a nested table structure using a dot-notation path.
---@param root? table | string The root table or global variable name, if nil, defaults to _G
---@param ... any The dot-notation path to the desired value.
---@return any
function F.Table.SafeGet(root, ...)
	assert(type(root) == "table" or type(root) == "string" or root == nil, "root must be a table, string, or nil")

	if root == nil then
		root = _G
	elseif type(root) == "string" then
		root = _G[root]
	end

	if root == nil then
		return nil
	end

	local parts = { ... }

	if #parts == 0 then
		return root
	end

	for _, part in ipairs(parts) do
		if type(root) ~= "table" then
			return nil
		end

		root = root[part]
	end

	return root
end

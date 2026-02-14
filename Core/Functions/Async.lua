local ns = select(2, ...) ---@type Namespace
local F = ns[2] ---@class Functions

---@class Functions.Async
F.Async = {}

---Delay the execution of a function by a specified number of seconds.
---@param seconds number The delay duration in seconds
---@param func function The function to execute after the delay
---@param ... any Additional arguments to pass to the function
function F.Async.Delay(seconds, func, ...)
	assert(type(seconds) == "number", "second should be a number")
	assert(type(func) == "function", "func should be a function")

	C_Timer.After(seconds, GenerateFlatClosure(func, ...) --[[@as function]])
end

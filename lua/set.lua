---@class SetMod
---@operator call: Set

---@alias HashAble string|number|boolean
---@alias Unit vim.NIL
local Unit = vim.NIL

-- TODO: complete Set methods.
---@class Set
---@field private _set table<HashAble, Unit>
local Set = {}
Set.__index = Set

---@return integer
function Set:__len()
	return #self._set
end

---@generic T: HashAble
---@return fun(): T?
function Set:iterator()
	return coroutine.wrap(function()
		for value in pairs(self._set) do
			coroutine.yield(value)
		end

		return nil
	end)
end

---@generic T: HashAble
---@param value T
---@return Set
function Set:__add(value)
	return vim.tbl_extend('force', {}, self._set, {[value] = Unit})
end

---@param other Set
function Set:__concat(other)
	for value in other:iterator() do
		self = self + value
	end

	return self
end

---@param other Set
---@return boolean
function Set:__eq(other)
	for value in self:iterator() do
		if not other._set[value] then
			return false
		end
	end

	return true
end

---@param other Set
---@return boolean
function Set:__lt(other)
	if #other > #self then
		return false
	end

	for value in self:iterator() do
		if not other._set[value] then
			return false
		end
	end

	return true
end

---@param other Set
---@return boolean
function Set:__le(other)
	return self < other
end

---@param other Set
---@return boolean
function Set:__gt(other)
	return other < self
end

---@param other Set
---@return boolean
function Set:__ge(other)
	return self > other
end

return setmetatable({}, {
	---@vararg HashAble
	__call = function (_, ...)
		local new = {
			_set = {}
		}
		for _, value in ipairs({...}) do
			new._set[value] = Unit
		end

		return setmetatable(new, Set)
	end
}) --[[@as SetMod]]

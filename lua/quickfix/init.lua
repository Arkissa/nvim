---@class quickfix.QuickfixMod
---@operator call: quickfix.Quickfix|quickfix.Location

---@class quickfix.Quickfix
local Quickfix = {}
Quickfix.__index = Quickfix

---@param what? table
---@return any
function Quickfix:getlist(what)
	return vim.fn.getqflist(what)
end

---@param list vim.quickfix.entry[]
---@param action string?
---@param what vim.fn.setqflist.what?
---@return integer
function Quickfix:setlist(list, action, what)
	if what then
		return vim.fn.setqflist(list, action, what)
	end

	return vim.fn.setqflist(list, action)
end

---
---@param nr integer?
function Quickfix:jump_first(nr)
	return vim.cmd.cc({ nargs = { nr }, mods = { silent = true } })
end

---@param height integer?
function Quickfix:open(height)
	return vim.cmd.copen({ nargs = { height } })
end

---@param height integer?
function Quickfix:window(height)
	return vim.cmd.cwindow({ nargs = { height } })
end

---@return boolean
function Quickfix:is_locat()
	return false
end

---@class quickfix.Location
---@field winnr integer
local Location = {}
Location.__index = Location

---@param what? table
---@return any
function Location:getlist(what)
	return vim.fn.getloclist(self.winnr, what)
end

---@param list vim.quickfix.entry[]
---@param action string?
---@param what vim.fn.setqflist.what?
---@return integer
function Location:setlist(list, action, what)
	if what then
		return vim.fn.setloclist(self.winnr, list, action, what)
	end

	return vim.fn.setloclist(self.winnr, list, action)
end

---@param height integer?
function Location:open(height)
	return vim.cmd.copen({ nargs = { height } })
end

---@param height integer?
function Location:window(height)
	return vim.cmd.cwindow({ nargs = { height } })
end

---@param nr integer?
function Location:jump_first(nr)
	return vim.cmd.ll({ nargs = { nr }, mods = { silent = true } })
end

---@return boolean
function Location:is_locat()
	return true
end

return setmetatable({}, {
	---@param winnr integer?
	---@return quickfix.Quickfix|quickfix.Location
	__call = function(_, winnr)
		if winnr then
			return setmetatable({ winnr = winnr }, Location)
		end

		return setmetatable({}, Quickfix)
	end
}) --[[@as quickfix.QuickfixMod]]

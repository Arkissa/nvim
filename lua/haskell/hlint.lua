local M = {}
local format = {
	[[%-G]],
	[[%-G%\\d%\\+\ hints]],
	[[%N%f:%l:%c:\ Suggestion:\ %m]],
	[[%N%f:%l:%c-%k:\ Suggestion:\ %m]],
	[[%I%f:%l:%c:\ Ignore:\ %m]],
	[[%I%f:%l:%c-%k:\ Ignore:\ %m]],
	[[%W%f:%l:%c:\ Warning:\ %m]],
	[[%W%f:%l:%c-%k:\ Warning:\ %m]],
	[[%E%f:%l:%c:\ Error:\ %m]],
	[[%E%f:%l:%c-%k:\ Error:\ %m]],
	[[%Z]],
}

local Haskell = require "haskell"
local Quickfix = require "quickfix"

local efm = vim.iter(format):join(',')
local hlint = {"hlint", "-s"}

local function workspace()
	return Path.root(0, Haskell.root_markers)
end

---@param flags string[]
---@param winnr integer?
---@param append boolean?
---@param bang boolean?
function M.hlint(flags, winnr, append, bang)
	local cmd = vim.list_extend({}, hlint)

	table.insert(cmd, winnr and vim.fn.expand("%:p") or workspace())

	local qf = Quickfix(winnr)

	qf:setlist({}, 'r', { title = "Hlint" })
	if not append then
		qf:setlist({}, 'r')
	end

	cmd = vim.list_extend(cmd, flags)

	vim.fn.jobstart(cmd, {
		stdout_buffered = false,
		on_stdout = vim.schedule_wrap(function (_, lines, _)
			if lines == nil or vim.tbl_isempty(lines) then
				return
			end

			qf:setlist({}, 'a', {efm = efm, lines = lines})
		end),
		on_exit = vim.schedule_wrap(function()
			vim.notify("Hlint done...", vim.log.levels.INFO)
			qf:window()
			if bang then
				qf:jump_first()
			end
		end)
	})
end

return M

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

local efm = vim.iter(format):join(',')
local hlint = {"hlint", "-s"}

local function workspace()
	return Path.root(0, Haskell.root_markers)
end

---@param flags string[]
---@param winnr integer?
function M.hlint(flags, winnr)
	local cmd = vim.list_extend({}, hlint)

	---@type fun(lines: string[])
	local setqflist = nil

	---@type function
	local open_list = nil

	if winnr then
		table.insert(cmd, vim.fn.expand("%:p"))
		setqflist = function (lines)
			vim.fn.setloclist(winnr, {}, 'a', {efm = efm, lines = lines})
		end
		open_list = function ()
			vim.cmd.lwindow()
		end
	else
		table.insert(cmd, workspace())
		setqflist = function (lines)
			vim.fn.setqflist({}, 'a', {efm = efm, lines = lines})
		end
		open_list = function ()
			vim.cmd.cwindow()
		end
	end

	cmd = vim.list_extend(cmd, flags)

	vim.fn.jobstart(cmd, {
		stdout_buffered = false,
		on_stdout = vim.schedule_wrap(function (_, lines, _)
			if lines == nil or vim.tbl_isempty(lines) then
				return
			end

			setqflist(lines)
		end),
		on_exit = vim.schedule_wrap(function ()
			vim.notify("Hlint done...", vim.log.levels.INFO)
			open_list()
		end)
	})
end

return M

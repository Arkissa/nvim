local M = {}

local Quickfix = require "quickfix"

---@class AsyncQuickfixOpts
---@field winnr integer? when set, will be use location.
---@field append boolean? when set, will not clear before quickfix list.
---@field on_exit fun(qf: quickfix.Location|quickfix.Quickfix)?
---@field on_stdout fun(invoke: (fun(list: vim.quickfix.entry[], action?: string, what?: vim.fn.setqflist.what): integer), lines: string[])

---@param cmd string|string[]
---@param opts AsyncQuickfixOpts?
function M.quickfix(cmd, opts)
	opts = opts or {}
	local qf = Quickfix(opts.winnr)
	if not opts.append then
		qf:setlist({}, 'r')
	end
	local on_stdout = opts.on_stdout or function(_, _)end
	local on_exit = opts.on_exit or function()end

	---@type fun(list: vim.quickfix.entry[], action?: string, what?: vim.fn.setqflist.what): integer
	local setlist = function(list, action, what)
		return qf:setlist(list, action, what)
	end

	vim.fn.jobstart(cmd, {
		stdout_buffered = false,
		on_stdout = vim.schedule_wrap(function(_, lines, _)
			if lines == nil or vim.tbl_isempty(lines) then
				return
			end

			on_stdout(setlist, lines)
		end),
		on_exit = vim.schedule_wrap(function()
			on_exit(qf)
		end)
	})
end

return M

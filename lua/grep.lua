local M = {}
M.__index = M

local Quickfix = require "quickfix"

---@param name string
---@return any|nil
local function get_option(name)
	local ok, result = pcall(vim.api.nvim_get_option_value, name, { scope = "global" })
	if not ok then
		ok, result = pcall(vim.api.nvim_get_option_value, name, { scope = "local" })
		if not ok then
			return nil
		end
	end

	if result == "" then
		return nil
	end

	return result
end

---@param flags string[]
---@param winnr integer?
---@param append boolean?
---@param bang boolean?
function M.Grep(flags, winnr, append, bang)
	local grepprg = get_option("grepprg")
	if grepprg == nil then
		return vim.notify("Not found grepprg option", vim.log.levels.ERROR)
	end

	local alternate_file_name = grepprg:match("#[^ ]*")

	if alternate_file_name ~= nil then
		grepprg = grepprg:gsub(alternate_file_name, vim.fn.expand(alternate_file_name))
	end

	local current_file_name = grepprg:match("%%:.*")
	if current_file_name ~= nil then
		grepprg = grepprg:gsub(current_file_name, vim.fn.expand(current_file_name))
	end

	grepprg = grepprg:gsub([[%$%*]], vim.iter(flags):join(" "))

	local gfm = get_option("grepformat")
	if gfm == nil then
		return vim.notify("Not found grepformat option", vim.log.levels.ERROR)
	end

	local qf = Quickfix(winnr)
	if not append then
		qf:setlist({}, 'r')
	end

	qf:setlist({}, 'r', { title = "Grep" })
	vim.fn.jobstart(grepprg, {
		stdout_buffered = false,
		on_stdout = vim.schedule_wrap(function(_, lines, _)
			if lines == nil or vim.tbl_isempty(lines) then
				return
			end

			qf:setlist({}, 'a', { efm = gfm, lines = lines })
		end),
		on_exit = vim.schedule_wrap(function()
			qf:window()
			if bang then
				qf:jump_first()
			end
		end)
	})
end

function M.create_command()
	vim.api.nvim_create_user_command("Grep", function(args)
		M.Grep(args.fargs, nil, false, args.bang)
	end, { nargs = "*", bang = true })

	vim.api.nvim_create_user_command("LGrep", function(args)
		M.Grep(args.fargs, vim.api.nvim_get_current_win(), false, args.bang)
	end, { nargs = "*", bang = true })

	vim.api.nvim_create_user_command("Grepadd", function(args)
		M.Grep(args.fargs, nil, true, args.bang)
	end, { nargs = "*", bang = true })

	vim.api.nvim_create_user_command("LGrepadd", function(args)
		M.Grep(args.fargs, vim.api.nvim_get_current_win(), true, args.bang)
	end, { nargs = "*", bang = true })
end

return M

local M = {}
M.__index = M

local AsyncCMD = require "async.cmd"

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
	---@type string
	local grepprg = get_option("grepprg")
	if grepprg == nil then
		return vim.notify("Not found grepprg option", vim.log.levels.ERROR)
	end

	local prg, count = grepprg:gsub([[%$%*]], vim.iter(flags):join(" "))
	if count == 0 then
		prg = vim.trim(prg) .. ' ' .. vim.iter(flags):join(' ')
	end
	---@type string
	prg = vim.fn.expandcmd(prg)

	local gfm = get_option("grepformat")
	if gfm == nil then
		return vim.notify("Not found grepformat option", vim.log.levels.ERROR)
	end

	AsyncCMD.quickfix(prg, {
		winnr = winnr,
		append = append,
		on_stdout = function(invoke, lines)
			invoke({}, 'a', { efm = gfm, lines = lines })
		end,
		on_exit = function(qf)
			qf:window()
			if bang then
				qf:jump_first()
			end
		end,
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

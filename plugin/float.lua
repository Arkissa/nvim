---@param bufnr integer
---@return integer
local function float_win(bufnr)
	return vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = math.ceil(vim.o.co * 0.7),
		height = math.ceil(vim.o.lines * 0.75),
		row = (0.5 - 0.75 / 2) * vim.o.lines - 1,
		col = (0.5 - 0.7 /  2) * vim.o.co,
		style = "minimal",
	})
end

vim.api.nvim_create_user_command("Float", function(opt)
	local bufnr, ok = opt.args:gsub("#", "")
	if ok == 1 then
		float_win(tonumber(bufnr, 10))
		return
	end

	float_win(0)
	vim.cmd(opt.args)
end, {
	nargs = '*',
	bar = true,
	complete = "command",
	desc = "Simple Float window like (v)split or command-modifies"
})

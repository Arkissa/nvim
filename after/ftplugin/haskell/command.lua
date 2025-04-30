local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_buf_create_user_command(bufnr, "Hlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, nil, false, opts.bang)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "LHlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, vim.api.nvim_get_current_win(), false, opts.bang)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "Hlintadd", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, nil, true, opts.bang)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "LHlintadd", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, vim.api.nvim_get_current_win(), true, opts.bang)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "EditCabal", function(opts)
	if opts.smods.vertical then
		vim.cmd.vsplit { mods = { split = opts.smods.split } }
	elseif opts.smods.horizontal or opts.smods.split ~= '' then
		vim.cmd.split { mods = { split = opts.smods.split } }
	end

	require "haskell".edit_project_cabal(vim.api.nvim_get_current_buf())
end, {
	nargs = 0
})

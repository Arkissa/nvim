local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_buf_create_user_command(bufnr, "Hlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "LHlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, vim.api.nvim_get_current_win())
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "Hlintadd", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, nil, true)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(bufnr, "LHlintadd", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, vim.api.nvim_get_current_win(), true)
end, {
	nargs = "*"
})

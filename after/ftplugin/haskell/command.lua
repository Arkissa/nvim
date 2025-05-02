local bufnr = vim.api.nvim_get_current_buf()

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

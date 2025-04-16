local qf = augroup("qf", { clear = false })

vim.api.nvim_create_user_command("Vimgrep", function (args)
	vim.cmd.vimgrep({ args = { string.format("/%s/j", args.args), "**/*" }, mods = { silent = true } })
end, { nargs = 1 })

autocmd("QuickFixCmdPost", {
	group = qf,
	nested = true,
	callback = function()
		if vim.tbl_isempty(vim.fn.getqflist()) then
			return
		end

		vim.cmd.copen()
	end
})

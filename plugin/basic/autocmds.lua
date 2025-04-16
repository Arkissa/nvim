local myvimrc = augroup("MYVIMRC", {
	clear = false,
})

autocmd("BufReadPost", {
	group = myvimrc,
	-- must be wait for filetype seted to run
	callback = vim.schedule_wrap(function ()
		local line = vim.fn.line([['"]])
		local filetype = vim.opt.filetype:get()
		if  line > 1
			and line <= vim.fn.line("$")
			and not vim.tbl_contains({'xxd', 'gitrebase', 'tutor', 'commit', 'help'}, filetype)
		then
			vim.api.nvim_input([[g`"]])
		end
	end)
})

autocmd("TextYankPost", {
	group = myvimrc,
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd({ "WinEnter", "BufEnter" }, {
	group = myvimrc,
	command = "setlocal cursorline"
})

autocmd({ "WinLeave", "BufLeave"}, {
	group = myvimrc,
	command = "setlocal nocursorline"
})

autocmd("TermEnter", {
	group = myvimrc,
	command = "setlocal nocursorline"
})

autocmd("BufEnter", {
	group = myvimrc,
	nested = true,
	callback = function(args)
		if vim.fn.winnr('$') < 2 and vim.bo[args.buf].buftype ~= '' then
			vim.cmd "q"
		end
	end
})

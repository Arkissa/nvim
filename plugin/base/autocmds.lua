local myvimrc = augroup("MYVIMRC", {
	clear = false,
})

autocmd("BufReadPost", {
	group = myvimrc,
	callback = function (_)
		local line = vim.fn.line([['"]])
		local filetype = vim.opt.filetype:get()
		if  line > 1
			and line <= vim.fn.line("$")
			and not vim.tbl_contains({'xxd', 'gitrebase', 'tutor', 'commit'}, filetype)
		then
			vim.cmd [[normal! g'"]]
		end
	end
})

autocmd("TextYankPost", {
	group = myvimrc,
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd("WinEnter", {
	group = myvimrc,
	command = "setlocal cursorline"
})

autocmd("WinLeave", {
	group = myvimrc,
	command = "setlocal nocursorline"
})

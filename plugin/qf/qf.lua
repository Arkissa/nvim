local qf = augroup("qf", { clear = false })
vim.o.quickfixtextfunc = "v:lua.require'quickfix.textfunc'.func"

autocmd("QuickFixCmdPost", {
	group = qf,
	callback = function()
		local ok = pcall(vim.cmd.lwindow)
		if not ok then
			vim.cmd.cwindow()
		end
	end
})

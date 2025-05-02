vim.o.quickfixtextfunc = "v:lua.require'quickfix.textfunc'.func"

Autocmd("QuickFixCmdPost", {
	group = Augroup("qf", { clear = false }),
	callback = function()
		local ok = pcall(vim.cmd.lwindow)
		if not ok then
			vim.cmd.cwindow()
		end
	end
})

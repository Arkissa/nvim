local qf = augroup("qf", { clear = false })
vim.o.quickfixtextfunc = "v:lua.require'quickfix.textfunc'.func"

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

local opt = vim.opt_local
opt.listchars:append { lead = "∙" }
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.formatprg = "hindent --indent-size 4"
autocmd("LspAttach", {
	group = augroup("haskell", {}),
	buffer = vim.api.nvim_get_current_buf(),
	callback = function (args)
		vim.bo[args.buf].formatexpr = ''
		vim.lsp.inlay_hint.enable(false)
	end
})

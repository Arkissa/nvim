local inlay_hint = augroup("inlay_hint", {})
autocmd("LspAttach", {
	desc = "startup inlay hints",
	group = inlay_hint,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if not client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
			return
		end

		vim.lsp.inlay_hint.enable()
	end
})

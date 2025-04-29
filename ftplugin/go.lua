local goroup = augroup("goroup", { clear = false })

autocmd("BufWritePre", {
	desc = "format .go file on save",
	callback = function()
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		---@diagnostic disable-next-line: inject-field
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, vim.lsp.protocol.Methods.textDocument_codeAction, params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format()
	end
})

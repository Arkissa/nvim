local document_highlight = augroup("document_highlight", { clear = false })
local methods = vim.lsp.protocol.Methods
vim.opt.updatetime = 300

autocmd("LspAttach", {
	group = document_highlight,
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if not client:supports_method(methods.textDocument_documentHighlight, args.buf) then
			return
		end

		local id = augroup("doc_highlight", { clear = false })
		autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = id,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight
		})
		autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			group = id,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references
		})
	end
})

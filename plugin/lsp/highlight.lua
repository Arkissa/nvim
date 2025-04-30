local document_highlight = Augroup("document_highlight", { clear = false })
local methods = vim.lsp.protocol.Methods
vim.opt.updatetime = 300

Autocmd("LspAttach", {
	group = document_highlight,
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if not client:supports_method(methods.textDocument_documentHighlight, args.buf) then
			return
		end

		local id = Augroup("doc_highlight", { clear = false })
		Autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = id,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight
		})
		Autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			group = id,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references
		})
	end
})

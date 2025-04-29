local set = vim.keymap.set
local methods = vim.lsp.protocol.Methods
local lsp = vim.lsp.buf

local function with(f, args)
	return function()
		return f(args)
	end
end

local function attach_keymaps(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	if client:supports_method(methods.textDocument_rename) then
		set("n", "<LEADER>r", lsp.rename, opts)
	end

	if client:supports_method(methods.textDocument_codeAction) then
		set({ "n", "x" }, "<LEADER>a", lsp.code_action, opts)
	end

	if client:supports_method(methods.textDocument_typeDefinition) then
		set("n", "gD", with(lsp.type_definition, { reuse_win = true }), opts)
	end

	if client:supports_method(methods.textDocument_references) then
		set("n", "g]", lsp.references, opts)
	end

	if client:supports_method(methods.textDocument_implementation) then
		set("n", "<LEADER>i", lsp.implementation, opts)
	end
end

autocmd("LspAttach", {
	group = augroup("lsp_keymaps", {}),
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		attach_keymaps(client, bufnr)
	end
})

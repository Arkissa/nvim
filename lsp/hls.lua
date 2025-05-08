---@type vim.lsp.Config
return {
	cmd = {"haskell-language-server-wrapper", "--lsp", "--logfile", vim.fs.joinpath(vim.fn.stdpath("log"), "haskell-language-server.log") },
	filetypes = { "haskell", "lhaskell", "cabal", "cabalproject" },
	root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" },
	on_init = function(client, _)
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.tbl_contains({ "cabal", "cabalproject" }, vim.bo[bufnr].filetype) then
			client.server_capabilities.documentHighlightProvider = false
		end

		-- I don't like inlay hint on haskell.
		client.server_capabilities.inlayHintProvider = false
	end,
	on_attach = function(client, bufnr)
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			-- Automatically refresh code lens.
			vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
				group = Augroup("hls-lens", {}),
				buffer = bufnr,
				callback = vim.schedule_wrap(vim.lsp.codelens.refresh),
			})
			-- refresh codelens right now!
			vim.lsp.codelens.refresh()
		end
	end,
	reuse_client = function()
		local bufnr = vim.api.nvim_get_current_buf()
		return not vim.tbl_contains({ "cabal", "cabalproject" }, vim.bo[bufnr].filetype)
	end,
	settings = {
		haskell = {
			formattingProvider = "fourmolu",
			maxCompletions = 40,
			checkParents = "CheckOnSave",
			checkProject = true,
			plugin = {
				-- highlight tokens
				semanticTokens = { globalOn = true },
				stan = { globalOn = true },
				eval = {
					config = { exception = true }
				},
				rename = {
					config = { crossModule = true },
				},
				["ghcide-type-lenses"] = {
					mode = { exported = true }
				},
				hlint = {
					diagnosticsOn = false,
				},
				fourmolu = {
					config = { external = true }
				}
			},
		},
	},
}

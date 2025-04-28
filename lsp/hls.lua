---@param client vim.lsp.Client
---@return lsp.ServerCapabilities
local function special_on_cabal(client)
	return vim.tbl_extend('force', client.server_capabilities, {
		inlayHintProvider = false,
		documentHighlightProvider = false,
	})
end

---@type vim.lsp.Config
return {
	cmd = {"haskell-language-server-wrapper", "--lsp", "--logfile", vim.fs.joinpath(vim.fn.stdpath("log"), "haskell-language-server.log") },
	filetypes = { "haskell", "lhaskell", "cabal", "cabalproject" },
	root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" },
	on_init = function(client, _)
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.tbl_contains({ "cabal", "cabalproject" }, vim.bo[bufnr].filetype) then
			client.server_capabilities = special_on_cabal(client)
			return
		end

		if vim.tbl_contains({"haskell", "lhaskell"}, vim.bo[bufnr].filetype) then
			-- I don't like inlay hint on haskell.
			client.server_capabilities.inlayHintProvider = false
		end
	end,
	on_attach = function(client, bufnr)
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			-- Automatically refresh code lens.
			vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
				group = augroup("hls-lens", {}),
				buffer = bufnr,
				callback = vim.schedule_wrap(vim.lsp.codelens.refresh),
			})
			-- refresh codelens right now!
			vim.lsp.codelens.refresh()
		end
	end,
	settings = {
		haskell = {
			formattingProvider = "fourmolu",
			maxCompletions = 40,
			checkParents = "CheckOnSave",
			checkProject = true,
			plugin = {
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
					config = {
						flags = {
							"--show"
						}
					}
				},
				fourmolu = {
					config = { external = true }
				}
			},
		},
	},
}

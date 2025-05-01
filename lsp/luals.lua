---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	root_markers = { ".git", '.luarc.json', '.luarc.jsonc', "stylua.toml", ".stylua.toml" },
	filetypes = { "lua" },
	on_init = function(client)
		client.server_capabilities.semanticTokensProvider = nil
	end,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library"
				}
			},
		},
	},
}

return {
    cmd = { "lua-language-server" },
	root_markers = { ".git", '.luarc.json', '.luarc.jsonc', "stylua.toml", ".stylua.toml" },
    filetypes = { "lua" },
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

local function has(server)
	if vim.fn.executable(server) == 0 then
		return function() end
	end

	return function(lsp)
		if not lsp.name then
			lsp.name = server
		end
		require 'lspconfig' [lsp.name].setup(lsp.config)
	end
end

has "lua-language-server" {
	name = "lua_ls",
	config = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					version = 'LuaJIT'
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library"
					}
				}
			})
		end,
		settings = {
			Lua = {}
		}
	}
}

has "gopls" {
	config = {
		settings = {
			gopls = {
				codelenses = {
					tests = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				usePlaceholders = true,
				gofumpt = true,
				analyses = {
					shadow = false,
					unusedparams = false,
				},
				staticcheck = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					constantValues = true,
					-- functionTypeParameters = true,
					rangeVariableTypes = true,
				}
			},
		}
	}
}

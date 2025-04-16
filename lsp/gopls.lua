return {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	-- root_dir = function(fname)
	-- 	local mod_cache = vim.fn.system 'go env GOMODCACHE'
	-- 	if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
	-- 		local clients = vim.lsp.get_clients { name = 'gopls' }
	-- 		if #clients > 0 then
	-- 			return clients[#clients].config.root_dir
	-- 		end
	-- 	end
	--
	-- 	return vim.fs.root(0, { 'go.work', 'go.mod', '.git' })
	-- end,
	root_markers = { "go.mod", "go.work", "go.sum", ".git" },
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

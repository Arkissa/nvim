return {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	root_markers = { "go.mod", "go.work", "go.sum" },
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

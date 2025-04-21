return {
	cmd = { 'haskell-language-server-wrapper', '--lsp' },
	filetypes = { 'haskell', 'lhaskell' },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(fname, { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml' }))
	end,
	settings = {
		haskell = {
			formattingProvider = '',
			cabalFormattingProvider = 'cabalfmt',
			checkParents = "CheckOnSave",
			checkProject = true,
			plugin = {
				alternateNumberFormat = { globalOn = true },
				callHierarchy = { globalOn = true },
				changeTypeSignature = { globalOn = true },
				class = {
					codeActionsOn = true,
					codeLensOn = true,
				},
				eval = {
					globalOn = true,
					config = {
						diff = true,
						exception = true,
					},
				},
				explicitFixity = { globalOn = true },
				gadt = { globalOn = true },
				['ghcide-code-actions-bindings'] = { globalOn = true },
				['ghcide-code-actions-fill-holes'] = { globalOn = true },
				['ghcide-code-actions-imports-exports'] = { globalOn = true },
				['ghcide-code-actions-type-signatures'] = { globalOn = true },
				['ghcide-completions'] = {
					globalOn = true,
					config = {
						autoExtendOn = true,
						snippetsOn = true,
					},
				},
				['ghcide-hover-and-symbols'] = {
					hoverOn = true,
					symbolsOn = true,
				},
				['ghcide-type-lenses'] = {
					globalOn = true,
					config = {
						mode = 'always',
					},
				},
				haddockComments = { globalOn = true },
				hlint = {
					codeActionsOn = true,
					diagnosticsOn = true,
				},
				importLens = {
					globalOn = true,
					codeActionsOn = true,
					codeLensOn = true,
				},
				moduleName = { globalOn = true },
				pragmas = {
					codeActionsOn = true,
					completionOn = true,
				},
				qualifyImportedNames = { globalOn = true },
				refineImports = {
					codeActionsOn = true,
					codeLensOn = true,
				},
				rename = {
					globalOn = true,
					config = { crossModule = true },
				},
				retrie = { globalOn = true },
				splice = { globalOn = true },
				tactics = {
					codeActionsOn = true,
					codeLensOn = true,
					config = {
						auto_gas = 4,
						hole_severity = nil,
						max_use_ctor_actions = 5,
						proofstate_styling = true,
						timeout_duration = 2,
					},
					hoverOn = true,
				},
			},
		},
	},
}

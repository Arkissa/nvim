vim.diagnostic.config {
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		scope = 'cursor',
	},
	signs = {
		text = {
		  [vim.diagnostic.severity.ERROR] = '✘',
		  [vim.diagnostic.severity.WARN] = '',
		  [vim.diagnostic.severity.HINT] = '',
		  [vim.diagnostic.severity.INFO] = '',
		},
		numhl = {
		  [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
		  [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
		  [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
		  [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
		},
	},
}
local diag = augroup("diag", { clear = true })

vim.keymap.set('n', '[e', function() vim.diagnostic.jump { count = -1, float = true } end)
vim.keymap.set('n', ']e', function() vim.diagnostic.jump { count = 1, float = true } end)

vim.api.nvim_create_user_command("Ldiag", function ()
	local ids = {}
	local bufnr = vim.api.nvim_get_current_buf()
	table.insert(ids, vim.api.nvim_create_autocmd('DiagnosticChanged', {
		group = diag,
		buffer = bufnr,
		callback = function(args)
			local diagnostics = vim.iter(args.data.diagnostics)
				:map(function(diagnostic)
					return {
						bufnr = diagnostic.bufnr,
						col = diagnostic.col + 1,
						end_col = diagnostic.end_col + 1,
						end_lnum = diagnostic.end_lnum + 1,
						lnum = diagnostic.lnum + 1,
						text = diagnostic.message,
						nr = 0,
						valid = 1,
					}
				end)
				:totable()

			vim.fn.setloclist(args.buf, diagnostics, 'u')
		end,
	}))
	vim.diagnostic.setloclist()
	vim.cmd.lopen()

	bufnr = vim.api.nvim_get_current_buf()
	table.insert(ids, vim.api.nvim_create_autocmd("WinClosed", {
		group = diag,
		buffer = bufnr,
		callback = function(args)
			for _, id in ipairs(ids) do
				vim.api.nvim_del_autocmd(id)
			end

			vim.fn.setloclist(args.buf, {}, 'r')
		end
	}))
end, {nargs = 0, desc = "Add current buffer diagnostics to the location list"})

vim.api.nvim_create_user_command("Cdiag", function ()
	local ids = {}
	local bufnr = vim.api.nvim_get_current_buf()
	table.insert(ids, vim.api.nvim_create_autocmd('DiagnosticChanged', {
		group = diag,
		buffer = bufnr,
		callback = function(args)
			local diagnostics = vim.iter(args.data.diagnostics)
				:map(function(diagnostic)
					return {
						bufnr = diagnostic.bufnr,
						col = diagnostic.col + 1,
						end_col = diagnostic.end_col + 1,
						end_lnum = diagnostic.end_lnum + 1,
						lnum = diagnostic.lnum + 1,
						text = diagnostic.message,
						nr = 0,
						valid = 1,
					}
				end)
				:totable()

			vim.fn.setqflist(diagnostics, 'u')
		end,
	}))
	vim.diagnostic.setqflist()
	vim.cmd.copen()

	bufnr = vim.api.nvim_get_current_buf()
	table.insert(ids, vim.api.nvim_create_autocmd("WinClosed", {
		group = diag,
		buffer = bufnr,
		callback = function()
			for _, id in ipairs(ids) do
				vim.api.nvim_del_autocmd(id)
			end

			vim.fn.setqflist({}, 'r')
		end
	}))
end, {nargs = 0, desc = "Add current buffer diagnostics to the quickfix list"})

local lsps = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
	:map(function (filename)
		filename = vim.fs.basename(filename)
		local i = filename:find("%.[^%.]*$")
		return filename:sub(1, i-1)
	end)
	:filter(function (name)
		return vim.fn.executable(vim.lsp.config[name].cmd[1]) == 1
	end)
	:totable()

vim.lsp.enable(lsps)

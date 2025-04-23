vim.api.nvim_create_user_command("Buffers", function (args)
	local buffers = vim.iter(vim.api.nvim_list_bufs())
		:filter(vim.api.nvim_buf_is_valid)
		:filter(function (bufnr)
			return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_line_count(bufnr) ~= 0
		end)

	if not args.bang then
		buffers = buffers:filter(vim.api.nvim_buf_is_loaded)
	end

	local bs = buffers
		:map(function(bufnr)
			return Buffer(bufnr):to_qfitem()
		end)
		:totable()

	vim.fn.setqflist(bs, 'r')
	vim.cmd.copen()
end, { bang = true, nargs = 0, desc = "Display buffers, buf display into the quickfix list." })

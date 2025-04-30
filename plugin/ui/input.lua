local api = vim.api
local wo = vim.wo
local bo = vim.bo
local input = Augroup("input", {})

local function keep_mode()
	if vim.api.nvim_get_mode().mode == 'i' then
		vim.api.nvim_input("<ESC>l")
	end
end

---@param opts {
---  prompt: string|nil,
---  default: string|nil,
---  completion: string|nil,
---  highlight: function|nil,
---}
---@param on_confirm fun(input: string|nil)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function (opts, on_confirm)
	local bufnr = api.nvim_create_buf(false, false)
	local winnr = api.nvim_open_win(bufnr, true, {
		relative = "cursor",
		width = math.max(20, api.nvim_strwidth(opts.default)),
		row = 1,
		col = -1,
		height = 1,
		style = "minimal",
		border = "rounded",
		title = { { (" %s "):format(vim.trim(opts.prompt) or "Input:"), "FloatBorder"} },
	})

	Autocmd({ "WinLeave", "BufLeave", "BufHidden" }, {
		group = input,
		buffer = bufnr,
		callback = function(args)
			api.nvim_buf_delete(args.buf, { force = true })
			on_confirm(nil)
		end
	})

	vim.keymap.set('n', "q", function ()
		keep_mode()
		api.nvim_buf_delete(bufnr, { force = true })

		on_confirm(nil)
	end, { buffer = bufnr, nowait = true, noremap = true })

	vim.keymap.set('n', "<ESC>", function ()
		keep_mode()
		api.nvim_buf_delete(bufnr, { force = true })

		on_confirm(nil)
	end, { buffer = bufnr, nowait = true, noremap = true })

	vim.keymap.set({'i', 'n'}, "<CR>", function ()
		local text = api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
		keep_mode()

		api.nvim_buf_delete(bufnr, { force = true })

		on_confirm(text)
	end, { buffer = bufnr, nowait = true, noremap = true })

	vim.keymap.set('i', "<Tab>", function ()
		return vim.keycode "<C-x><C-u>"
	end, { noremap = true, expr = true, buffer = bufnr })

	wo[winnr].wrap = false

	bo[bufnr].filetype = ""
	bo[bufnr].buftype = "nofile"
	bo[bufnr].bufhidden = "wipe"

	if opts.default then
		api.nvim_buf_set_lines(bufnr, 0, -1, false, { opts.default })
		api.nvim_feedkeys("0vg_o", "nx", false)
	else
		api.nvim_feedkeys("A", "nx", false)
	end

	if opts.completion then
		--- https://github.com/xiaoshihou514/nvim/blob/9f950a7ce8749e0f31883a96e68264e0d2ebcc78/after/plugin/input.lua#L28
		_G.input_cfu = function (findstart, base)
			if findstart == 1 then
				return 0
			end
			local ok, result = pcall(vim.fn.getcompletion, base, opts.completion)
			return ok and result or {}
		end

		vim.bo[bufnr].completefunc = "v:lua.input_cfu"
	end
end

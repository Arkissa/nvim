local select = augroup("select", {})
local api = vim.api
local bo = vim.bo

---@return integer
local function win_open(height, width, title)
	local bufnr = api.nvim_create_buf(false, false)
	local winnr = api.nvim_open_win(bufnr, true, {
		relative = 'cursor',
		row = 1,
		col = -1,
		height = height,
		width = math.min(100, width),
		style = "minimal",
		border = "rounded",
		title = { { (" %s "):format(vim.trim(title)), "FloatBorder"} },
		title_pos = 'center',
	})

	vim.wo[winnr].wrap = false
	return bufnr
end

local function set_lines(bufnr, lines)
	bo[bufnr].buftype = "nofile"
	bo[bufnr].bufhidden = "wipe"
	api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	bo[bufnr].readonly = true
	bo[bufnr].modifiable = false
end

---@param items any[]
---@param opts {prompt: string|nil, format_item: fun(item: any): string}
---@param on_choice fun(item: any?, idx: integer?)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
	if vim.tbl_isempty(items) then
		error("items must be non-empty.")
	end
	local abort = function()
		on_choice(nil)
	end

	local formatted = vim.tbl_map(opts.format_item, items)
	local max_len_item = vim.fn.max(vim.iter(formatted)
		:map(function(item)
			return #item
		end):totable())

	local bufnr = win_open(#items, max_len_item, opts.prompt or "Select:")

	set_lines(bufnr, vim.iter(ipairs(formatted))
		:map(function(i, v)
			local padding = tonumber(#tostring(#formatted)) + 1
			return ("(%%-%dd%%s"):format(padding):format(i, v)
		end)
		:totable())

	autocmd({ "WinLeave", "BufLeave", "BufHidden" }, {
		group = select,
		buffer = bufnr,
		callback = function(args)
			api.nvim_buf_delete(args.buf, { force = true })
			abort()
		end
	})

	vim.keymap.set('n', "q", function ()
		api.nvim_buf_delete(bufnr, { force = true })
		abort()
	end, { noremap = true, buffer = bufnr })
	vim.keymap.set('n', "<ESC>", function ()
		api.nvim_buf_delete(bufnr, { force = true })
		abort()
	end, { noremap = true, buffer = bufnr })

	vim.keymap.set('n', "<CR>", function ()
		local idx = api.nvim_win_get_cursor(bufnr)[1]
		api.nvim_buf_delete(bufnr, { force = true })
		on_choice(items[idx], idx)
	end, { noremap = true, buffer = bufnr })
end

local select = augroup("select", {})
local api = vim.api
local bo = vim.bo

---@return {winnr: integer, bufnr: integer}
local function win_open(height, width, title)
	local bufnr = api.nvim_create_buf(false, false)
	local winnr = api.nvim_open_win(bufnr, true, {
		relative = 'cursor',
		row = 1,
		col = -1,
		height = height,
		width = math.min(200, math.max(50, width)),
		style = "minimal",
		border = "rounded",
		title = { { (" %s "):format(vim.trim(title)), "FloatBorder"} },
		title_pos = 'center',
	})

	vim.wo[winnr].wrap = false
	return {winnr = winnr, bufnr = bufnr}
end

local function set_lines(bufnr, lines)
	bo[bufnr].buftype = "nofile"
	bo[bufnr].bufhidden = "wipe"
	bo[bufnr].filetype = "markdown"
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

	local choice = function(bufnr, item, idx)
		api.nvim_buf_delete(bufnr, { force = true })
		on_choice(item, idx)
	end

	local formatted = vim.tbl_map(opts.format_item, items)
	local max_len_item = vim.fn.max(vim.iter(formatted)
		:map(function(item)
			return #item
		end)
		:totable())

	local win = win_open(#items, max_len_item, opts.prompt or "Select:")

	set_lines(win.bufnr, vim.iter(ipairs(formatted))
		:map(function(i, v)
			local padding = #tostring(#formatted) + 2
			return ("%%-%ds%%s"):format(padding):format(tostring(i)..'.', v)
		end)
		:totable())

	autocmd({ "WinLeave", "BufLeave", "BufHidden" }, {
		group = select,
		buffer = win.bufnr,
		callback = function(args)
			choice(args.buf)
		end
	})

	vim.keymap.set('n', "q", function()
		choice(win.bufnr)
	end, { noremap = true, buffer = win.bufnr })

	vim.keymap.set('n', "<ESC>", function()
		choice(win.bufnr)
	end, { noremap = true, buffer = win.bufnr })

	vim.keymap.set('n', "<CR>", function()
		local idx = api.nvim_win_get_cursor(win.winnr)[1]
		choice(win.bufnr, items[idx], idx)
	end, { noremap = true, buffer = win.bufnr })
end

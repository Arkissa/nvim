local myvimrc = Augroup("MYVIMRC", {
	clear = false,
})
local pumvisible = vim.fn.pumvisible
local feedkeys = vim.api.nvim_feedkeys

Autocmd("TextYankPost", {
	group = myvimrc,
	callback = function()
		vim.hl.on_yank()
	end,
})

Autocmd({ "WinEnter", "BufEnter" }, {
	group = myvimrc,
	command = "setlocal cursorline"
})

Autocmd({ "WinLeave", "BufLeave"}, {
	group = myvimrc,
	command = "setlocal nocursorline"
})

Autocmd("TermEnter", {
	group = myvimrc,
	command = "setlocal nocursorline"
})

Autocmd("BufEnter", {
	group = myvimrc,
	nested = true,
	callback = function()
		local ok = vim.iter(vim.api.nvim_list_wins())
			:all(function(winnr)
				local bufnr = vim.api.nvim_win_get_buf(winnr)
				return vim.bo[bufnr].buftype ~= ""
			end)

		if ok then
			vim.cmd "quitall"
		end
	end
})

Autocmd("InsertCharPre", {
	group = myvimrc,
	desc = "Autocompletion omnifunc.",
	callback = function()
		if pumvisible() == 1 or vim.fn.state 'm' == 'm'
		then
			return
		end

		local char = vim.v.char

		if char:match("[^%w.:]") then
			return
		end

		if vim.opt.omnifunc:get() == "" then
			return
		end

		feedkeys(vim.keycode "<C-X><C-O>", "im", false)
	end
})

Autocmd("CompleteChanged", {
	group = myvimrc,
	desc = "highlight preview window",
	callback = function()
		local info = vim.fn.complete_info({ "selected" })
		if info.preview_bufnr and vim.bo[info.preview_bufnr].filetype == "" then
			vim.bo[info.preview_bufnr].filetype = "markdown"
			vim.wo[info.preview_winid].conceallevel = 2
			vim.wo[info.preview_winid].concealcursor = "niv"
		end
	end,
})


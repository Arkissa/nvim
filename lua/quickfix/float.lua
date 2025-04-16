---@class quickfix.FloatWin
---@field private _winnr integer
---@field private _win_conf vim.api.keyset.win_config
---@field private _on_buf_before fun(bufnr: integer)[]
---@field private _on_buf_post fun(bufnr: integer)[]
---@field private _on_close fun(args: [integer, integer])[]
local FloatWin = {}
FloatWin.__index = FloatWin

local M = {}

---@return quickfix.FloatWin
function M.open(qfwinnr)
	local win_conf = {
		relative = 'win',
		win = qfwinnr,
		width = vim.o.co,
		height = math.ceil((vim.o.lines - vim.api.nvim_win_get_height(qfwinnr)) * 0.5),
		anchor = 'SW',
		focusable = false,
		mouse = false,
		col = vim.o.co,
		row = -1,
		zindex = 52,
		style = "minimal",
		border = "rounded",
	}

	local winnr = vim.api.nvim_open_win(0, false, win_conf)
	local wo = vim.wo[winnr]
	wo.fen, wo.fdm, wo.fdc = false, 'manual', '0'
	wo.scrolloff = 0

	return setmetatable({
		_winnr = winnr,
		_win_conf = win_conf,
		_on_buf_post = {},
		_on_buf_before = {},
		_on_close = {},
	}, FloatWin)
end

---@param bufnr integer
function FloatWin:set_buf(bufnr)
	for _, f in ipairs(self._on_buf_before) do
		f(vim.api.nvim_win_get_buf(self._winnr))
	end

	vim.api.nvim_win_set_buf(self._winnr, bufnr)

	for _, f in ipairs(self._on_buf_post) do
		f(bufnr)
	end
end

---@param title string|[string, string][]
function FloatWin:set_title(title)
	self._win_conf.title = title
	vim.api.nvim_win_set_config(self._winnr, self._win_conf)
end

---@param lnum integer
---@param col  integer
function FloatWin:set_cursor(lnum, col)
	vim.api.nvim_win_set_cursor(self._winnr, { lnum, col })
end

---@param f fun(bufnr: integer)
function FloatWin:on_buf_before(f)
	table.insert(self._on_buf_before, f)
end

---@param f fun(bufnr: integer)
function FloatWin:on_buf_post(f)
	table.insert(self._on_buf_post, f)
end

---@param f fun(args: [integer, integer])
function FloatWin:on_close(f)
	table.insert(self._on_close, f)
end

function FloatWin:close()
	for _, f in ipairs(self._on_close) do
		f({ self._winnr, vim.api.nvim_win_get_buf(self._winnr) })
	end

	vim.api.nvim_win_close(self._winnr, true)
end

---@param key string
function FloatWin:feedkeys(key)
	vim.api.nvim_win_call(self._winnr, function ()
		vim.api.nvim_feedkeys(key, 'nx', true)
	end)
end

return M

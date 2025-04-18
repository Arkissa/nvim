---@class BufferMod
---@operator call: buffers.Buffer

---@class buffers.Buffer
---@field _bufnr integer
local Buffer = {}
Buffer.__index = Buffer

---@return string
function Buffer:name()
	return vim.api.nvim_buf_get_name(self._bufnr)
end

---@return [integer, integer]
function Buffer:last_pos()
	return vim.api.nvim_buf_get_mark(self._bufnr, '"')
end

---@return integer
function Buffer:bufnr()
	return self._bufnr
end

---@return {
---  bufnr: integer,
---  module: string,
---  nr: integer,
---  pattern: string,
---  lnum: integer,
---  end_lnum: integer,
---  col: integer,
---  end_col: integer,
---  text: string,
---  type: string,
---  vaild: integer,
---  vcol: integer,
---}
function Buffer:to_qfitem()
	local pos = self:last_pos()
	local lines = {}
	if self:is_binary() then
		lines = { vim.fs.basename(self:name()) }
	else
		lines = vim.api.nvim_buf_get_lines(self:bufnr(), pos[1] - 1, pos[2] - 1, false)
		if not lines or vim.tbl_isempty(lines) then
			lines = { "" }
		end
	end

	return {
		bufnr = self:bufnr(),
		col = pos[2],
		end_col = pos[2],
		end_lnum = pos[1],
		lnum = pos[1],
		nr = 0,
		text = lines[1],
		valid = 1,
	}
end

function Buffer:load()
	vim.fn.bufload(self:bufnr())
end

function Buffer:is_binary()
	--- https://github.com/Donaldttt/fuzzyy/blob/966122c3f5f3b524c5dbe30e63f2ad7b841a5fba/autoload/fuzzyy/utils/selector.vim#L101C46-L101C53
	return vim.fn.match(vim.fn.readfile(self:name(), '', 10), [[\%x00]]) ~= -1
end

function Buffer:get_lines(start, end_start)
	return vim.api.nvim_buf_get_lines(self:bufnr(), start, end_start, false)
end

function Buffer:is_loaded()
	return vim.api.nvim_buf_is_loaded(self:bufnr())
end

return setmetatable({}, {
	---@param b integer|string
	---@return buffers.Buffer
	__call = function(_, b)
		return setmetatable({ _bufnr = type(b) == "string" and vim.fn.bufadd(b) or b }, Buffer)
	end
}) --[[@as BufferMod]]

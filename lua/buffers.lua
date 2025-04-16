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
	local lines = vim.api.nvim_buf_get_lines(self:bufnr(), pos[1] - 1, pos[2] - 1, false)
	if not lines or vim.tbl_isempty(lines) then
		lines = { "" }
	end

	return {
		bufnr = self:bufnr(),
		col = pos[2],
		end_col = pos[2],
		end_lnum = pos[1],
		lnum = pos[1],
		module = "",
		nr = 0,
		pattern = "",
		text = lines[1],
		type = "",
		valid = 1,
		vcol = 0
	}
end

return setmetatable({}, {
	---@param bufnr integer
	---@return buffers.Buffer
	__call = function (_, bufnr)
		return setmetatable({ _bufnr = bufnr }, Buffer)
	end
}) --[[@as BufferMod]]

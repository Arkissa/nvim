local M = {}

local function getqflist(info)
	if info.quickfix == 1 then
		return vim.fn.getqflist({id = info.id, items = 1})
	end

	return vim.fn.getloclist(info.winid, {id = info.id, items = 1})
end

---@return integer
local function get_lnum_and_col_length(item)
	return #("%d:%d"):format(item.lnum, item.col)
end

---@return string
local function get_bufname(bufnr)
	local bname = vim.api.nvim_buf_get_name(bufnr)
	return vim.fs.relpath(vim.fn.getcwd(), bname) or bname:gsub('^' .. vim.env.HOME, '~', 1)
end

---@return {name: integer, lnum_and_col: integer, type: integer}
local function get_max_lengths(items)
	local lengths = {
		name = #get_bufname(items[1].bufnr),
		lnum_and_col = get_lnum_and_col_length(items[1]),
		type = #items[1].type
	}

	for i = 2, #items do
		local item = items[i]
		local name_length = #get_bufname(item.bufnr)
		if lengths.name < name_length then
			lengths.name = name_length
		end

		local lnum_and_col_length = get_lnum_and_col_length(item)
		if lengths.lnum_and_col < lnum_and_col_length then
			lengths.lnum_and_col = lnum_and_col_length
		end

		local type_length = #item.type
		if lengths.type < type_length then
			lengths.type = type_length
		end
	end

	return lengths
end

function M.func(info)
	local qflist = getqflist(info).items
   	if #qflist == 0 then
		return {}
	end

	local length = get_max_lengths(qflist)
	return vim.iter(qflist)
		:map(function(item)
			local fname = get_bufname(item.bufnr)
			return ("%-" .. tostring(length.name) .. "s |%" .. tostring(length.lnum_and_col+1) .. "s%-"..tostring(length.type+1).."s| %s")
				:format(fname, ("%d:%d"):format(item.lnum, item.col), item.type, item.text)
		end)
		:totable()
end

return M

local M = {}

local function getqflist(info)
	if info.quickfix == 1 then
		return vim.fn.getqflist({id = info.id, items = 1})
	end

	return vim.fn.getloclist(info.winid, {id = info.id, items = 1})
end

---@return string
local function get_lnum_and_col(item)
	local s = {}
	if item.lnum and item.lnum > 0 then
		table.insert(s, "%d")
	end

	if item.col and item.col > 0 then
		table.insert(s, "%d")
	end

	return (vim.iter(s):join(':')):format(item.lnum, item.col)
end

---@return string
local function get_bufname(bufnr)
	local bname = vim.api.nvim_buf_get_name(bufnr)
	bname = vim.fs.relpath(vim.fn.getcwd(), bname) or bname:gsub('^' .. vim.env.HOME, '~', 1)
	if bname == '.' then
		return ""
	else
		return bname
	end
end

---@param bufname string
---@return string
local function get_fname(bufname, max_len)
	if #bufname <= max_len then
		return bufname
	end

	return "…" .. bufname:sub(bufname:len() - max_len+2)
end

---@return {name: integer, lnum_and_col: integer, type: integer}
local function get_max_lengths(items)
	local lengths = {
		name = #get_bufname(items[1].bufnr),
		lnum_and_col = #get_lnum_and_col(items[1]),
		type = #items[1].type
	}

	for i = 2, #items do
		local item = items[i]
		local name_length = #get_bufname(item.bufnr)
		if lengths.name < name_length then
			lengths.name = name_length
		end

		local lnum_and_col_length = #get_lnum_and_col(item)
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
	local max_fname_width = math.min(length.name, math.floor(math.min(95, vim.o.columns / 4)))
	local tlen = length.type ~= 0 and length.type + 1 or 0

	return vim.iter(qflist)
		:map(function(item)
			local fname = get_fname(get_bufname(item.bufnr), max_fname_width)

			local lc = get_lnum_and_col(item)
			local line = "%-"..tostring(tlen).."s%-" .. tostring(max_fname_width) .. "s │%" .. tostring(length.lnum_and_col) .. "s│%" .. tostring(math.min(99, #item.text+1)) .."s"
			return line:format(item.type, fname, lc, item.text)
		end)
		:totable()
end

return M

---@class quickfix.Preview
---@field private _winnr integer
---@field private _bufnr integer
---@field private _float_win quickfix.FloatWin
local pw = {}
pw.__index = pw

local ns_id = vim.api.nvim_create_namespace("quickfix.preview")
local qfgroup = vim.api.nvim_create_augroup("qf", { clear = false })
local Float = require "quickfix.float"

---@param winnr integer
---@return table|nil
local function get_qflist(winnr)
	local winfo = vim.fn.getwininfo(winnr)[1]
	if winfo.quickfix == 0 then
		return nil
	end

	return winfo.loclist == 1
		and vim.fn.getloclist(winnr)
		or vim.fn.getqflist()
end

---@return integer
local function get_cursor_lnum()
	return vim.api.nvim_win_get_cursor(pw._winnr)[1]
end

---@param item table | nil
---@return {lnum: integer, col: integer, end_row: integer, end_col: integer}|nil
local function get_extmark_pos(item)
	if item == nil then
		return nil
	end

	local pos = {
		lnum = math.max(0, item.lnum - 1),
		col = math.max(0, item.col - 1),
	}

	pos.end_row = math.max(pos.lnum, item.end_lnum - 1)
	pos.end_col = math.max(pos.col+1, item.end_col - 1)

	return pos
end

---@return integer
local function set_buf_hl(bufnr, pos)
	return vim.api.nvim_buf_set_extmark(bufnr, ns_id, pos.lnum, pos.col, {
		hl_group = "TermCursor",
		end_col = pos.end_col,
		end_row = pos.end_row,
	})
end

---@param item table
---@return string | nil
local function preview_title(item)
	local bname = vim.api.nvim_buf_get_name(item.bufnr)
	-- https://github.com/kevinhwang91/nvim-bqf/blob/e20417d5e589e03eaaaadc4687904528500608be/lua/bqf/preview/floatwin.lua#L183
	return (" [%d/%d] buf %d: %s %s"):format(
		item.lnum,                                                                   -- position number of line
		vim.api.nvim_buf_line_count(item.bufnr),                                     -- position number of col
		item.bufnr,                                                                  -- bufnr
		vim.fs.relpath(vim.fn.getcwd(), bname) or bname:gsub('^' .. vim.env.HOME, '~', 1), -- name of preview file
		vim.bo[item.bufnr].modified and "[+]" or ''                                 -- buffer modified status
	)
end

---@param fname string
---@return true
local function is_binary(fname)
	--- https://github.com/Donaldttt/fuzzyy/blob/966122c3f5f3b524c5dbe30e63f2ad7b841a5fba/autoload/fuzzyy/utils/selector.vim#L101C46-L101C53
	return vim.fn.match(vim.fn.readfile(fname, '', 10), [[\%x00]]) ~= -1
end

local function detect_filetype(bufnr, bname)
	return vim.filetype.match({
		filename = bname,
		buf = bufnr
	})
end

---@param float quickfix.FloatWin
---@param list table
local function set_buf_with_under_cursor(float, list)
	if vim.tbl_isempty(list) then
		return
	end

	local item = list[get_cursor_lnum()]
	local bname = vim.api.nvim_buf_get_name(item.bufnr)

	if item.valid ~= 1 or is_binary(bname) then
		return vim.notify("can't preview this item")
	end

	float:set_buf(item.bufnr)
	local title = preview_title(item)
	if title then
		float:set_title({ {title, "FloatBorder"} })
	end

	if vim.bo[item.bufnr].filetype == "" then
		vim.bo[item.bufnr].filetype = detect_filetype(item.bufnr, vim.fn.fnameescape(bname))
	end
	float:set_cursor(item.lnum, item.col)
	float:feedkeys("zz")
end

---@param winnr integer
---@param nsid integer
---@return quickfix.FloatWin
local function float_open(winnr, nsid)
	local f = Float.open(winnr)
	f:on_buf_before(function(args)
		vim.api.nvim_buf_clear_namespace(args.bufnr, ns_id, 0, -1)
	end)

	f:on_buf_post(function(args)
		local qflist = assert(get_qflist(pw._winnr))
		local pos = get_extmark_pos(qflist[get_cursor_lnum()])
		if pos == nil then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(args.bufnr, pos.lnum, pos.end_row, true)
		if vim.tbl_isempty(lines) then
			return
		end

		if vim.iter(lines):all(function(line)
			return line == ""
		end) then
			return
		end

		set_buf_hl(args.bufnr, pos)
	end)

	f:on_close(function(args)
		vim.api.nvim_buf_clear_namespace(args.bufnr, nsid, 0, -1)
	end)

	return f
end

local function float_close()
	pw._float_win:close()
	pw._float_win = nil
end

---@return integer
local function create_qfwin_quit(bufnr)
	return vim.api.nvim_create_autocmd({ "WinLeave", "WinClosed", "WinLeave", "BufWipeout", "BufHidden" }, {
		group = qfgroup,
		buffer = bufnr,
		callback = function()
			if pw._float_win then
				float_close()
			end
		end
	})
end

---@return integer
local function create_qfwin_cursor_moved(bufnr)
	return vim.api.nvim_create_autocmd("CursorMoved", {
		group = qfgroup,
		buffer = bufnr,
		callback = function()
			local qflist = assert(get_qflist(pw._winnr))
			set_buf_with_under_cursor(pw._float_win, qflist)
		end
	})
end

local function hook_cr()
	vim.on_key(function(key, _)
		if vim.api.nvim_get_current_win() ~= pw._winnr then
			return
		end

		if vim.fn.keytrans(key) == "<CR>" and pw._float_win then
			return float_close()
		end
	end, ns_id)

	pw._float_win:on_close(function(_)
		vim.on_key(nil, ns_id)
	end)

end

---@param float quickfix.FloatWin
---@param bufnr integer
---@param key string
---@param command string
local function create_keymap(float, bufnr, key, command)
	vim.keymap.set('n', key, function ()
		float:feedkeys(command)
	end, { noremap = true, silent = true, buffer = bufnr })

	float:on_close(function (_)
		vim.keymap.del('n', key, { buffer = bufnr })
	end)
end

---@param float quickfix.FloatWin
local function create_autocmd(float, bufnr)
	local autocmd_ids = {}
	table.insert(autocmd_ids, create_qfwin_quit(bufnr))
	table.insert(autocmd_ids, create_qfwin_cursor_moved(bufnr))

	float:on_close(function(_)
		for _, id in ipairs(autocmd_ids) do
			pcall(vim.api.nvim_del_autocmd, id)
		end
	end)
end

local function create_toggle_floatwin(bufnr)
	vim.keymap.set('n', "K", function ()
		local qflist = assert(get_qflist(pw._winnr))
		if vim.tbl_isempty(qflist) then
			return vim.notify("list is empty.", vim.log.levels.ERROR)
		end

		if pw._float_win then
			return float_close()
		end

		pw._float_win = float_open(pw._winnr, ns_id)

		hook_cr()
		create_autocmd(pw._float_win, bufnr)
		create_keymap(pw._float_win, bufnr, "<C-u>", "zz") -- scroll up a half page on floating preview window
		create_keymap(pw._float_win, bufnr, "<C-d>", "zz") -- scrool down a half page on floating preview window
		create_keymap(pw._float_win, bufnr, "gg", "gg") -- go to top line on floating preview window
		create_keymap(pw._float_win, bufnr, "G", "G") -- go to top line on floating preview window
		set_buf_with_under_cursor(pw._float_win, qflist)
	end, { noremap = true, buffer = bufnr })
end

function pw.preview_on_float(winnr)

	pw._winnr = winnr
	pw._bufnr = vim.api.nvim_win_get_buf(winnr)
	create_toggle_floatwin(pw._bufnr)
end

return pw

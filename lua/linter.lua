---@class LinterMode
---@operator call: nil

local AsyncCMD = require "async.cmd"

---@type {[integer]: {cmd: string, efm: string}}
local last_cmds = {}

---@param flags string[]
---@param bufnr integer
---@return {cmd: string, efm: string}?
local function get_cmd(flags, bufnr)
	if vim.tbl_isempty(flags) and last_cmds[bufnr] then
		return last_cmds[bufnr]
	end

	---@type string
	local prg = vim.b[bufnr].lintprg
	if prg == nil or prg == "" then
		return nil
	end

	local efm = vim.b[bufnr].lintformat
	if efm == nil then
		efm = ""
	end

	local count
	prg, count = prg:gsub([[%$%*]], vim.iter(flags):join(" "))
	if count == 0 then
		prg = vim.trim(prg) .. ' ' .. vim.iter(flags):join(' ')
	end

	return {cmd = vim.fn.expandcmd(prg), efm = efm}
end

---@param flags string[]
---@param bang boolean?
---@param winnr integer?
local function linter(_, flags, bang, winnr)
	local bufnr = vim.api.nvim_get_current_buf()

	local prg = get_cmd(flags, bufnr)
	if prg == nil then
		return vim.notify("lintprg can't empty", vim.log.levels.ERROR)
	end

	AsyncCMD.quickfix(prg.cmd, {
		bang = bang,
		winnr = winnr,
		on_stdout = function(invoke, lines)
			invoke({}, 'a', {efm = prg.efm, lines = lines})
		end,
		on_exit = function(qf)
			qf:window()
			if bang then
				qf:jump_first()
			end

			last_cmds[bufnr] = prg
		end
	})
end

return setmetatable({}, {
	__call = linter
}) --[[@as LinterMode]]

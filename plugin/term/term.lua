---@class Mod
---@field vertical boolean
---@field horizontal boolean
---@field tab boolean
---@field split "aboveleft" | "belowright" | "topleft" | "botright"

---@class Term
---@field private bufnr integer
---@field private winnr integer
---@field private cmd string | string[]
local Term = {}

---@type Term
local LastTerm = nil

---@param mod Mod
---@param bufnr integer?
---@return Term
function Term.new(mod, bufnr)
	if mod.vertical then
		vim.cmd.vsplit { mods = { split = mod.split } }
	elseif mod.horizontal or mod.split ~= '' then
		vim.cmd.split { mods = { split = mod.split } }
	end

	if mod.tab then
		vim.cmd.tabnew()
	else
		bufnr = bufnr or vim.api.nvim_create_buf(true, false)
		vim.api.nvim_set_current_buf(bufnr)
	end

	return setmetatable({
			bufnr = bufnr,
		},
		{
			__index = Term
		})
end

---@return boolean
function Term:is_valid()
	return vim.api.nvim_buf_is_loaded(self.bufnr)
end

---@param cmd string | string[]
function Term:open(cmd)
	vim.fn.jobstart(cmd, {
		cwd = vim.fn.getcwd(),
		term = true
	})
	vim.cmd.startinsert()
end

---@return integer
function Term:get_bufnr()
	return self.bufnr
end

---@return string
function Term:get_cmd()
	local bname = vim.split(vim.api.nvim_buf_get_name(self.bufnr), ":")
	local cmd, _ = bname[#bname]:gsub("^"..vim.env.HOME, "~")
	return cmd
end

---@param winnr integer
---@param title string
local function set_title(winnr, title)
	local conf = vim.api.nvim_win_get_config(winnr)
	conf.title = title
	conf.title_pos = "center"
	vim.api.nvim_win_set_config(winnr, conf)
end

vim.api.nvim_create_user_command("Term", function (args)
	local mod = {
		vertical = args.smods.vertical,
		horizontal = args.smods.horizontal,
		tab = args.smods.tab ~= -1,
		split = args.smods.split
	}

	if args.bang and LastTerm and vim.api.nvim_buf_is_loaded(LastTerm:get_bufnr()) then
		LastTerm = Term.new(mod, LastTerm:get_bufnr())
	else
		local term = Term.new(mod)
		term:open(#args.fargs > 0 and args.fargs or { vim.env.SHELL })
		LastTerm = term
	end

	local winnr = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(winnr).relative ~= '' then
		set_title(winnr, LastTerm:get_cmd())
	end
end, { nargs = '*', bang = true, desc = "Simply wrap term command" })

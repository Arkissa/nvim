local opt = vim.opt_local
opt.listchars:append { lead = "∙" }
opt.list = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
-- opt.formatprg = "hindent --indent-size 4"

local setb = vim.api.nvim_buf_set_var

local format = {
	[[%-G]],
	[[%-G%\\d%\\+\ hints]],
	[[%-GNo hints]],
	[[%N%f:%l:%c:\ Suggestion:\ %m]],
	[[%N%f:%l:%c-%k:\ Suggestion:\ %m]],
	[[%I%f:%l:%c:\ Ignore:\ %m]],
	[[%I%f:%l:%c-%k:\ Ignore:\ %m]],
	[[%W%f:%l:%c:\ Warning:\ %m]],
	[[%W%f:%l:%c-%k:\ Warning:\ %m]],
	[[%E%f:%l:%c:\ Error:\ %m]],
	[[%E%f:%l:%c-%k:\ Error:\ %m]],
	[[%Z]],
}

setb(0, "lintprg", "hlint")
setb(0, "lintformat", vim.iter(format):join(','))

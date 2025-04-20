local qf = augroup("qf", { clear = false })
local Finder = require "quickfix.find"
local finder = Finder()

vim.api.nvim_create_user_command("Grep", function (args)
	vim.cmd[args.bang and "vimgrepadd" or "vimgrep"]({ args = { string.format("/%s/gj", args.args), "**/*" }, mods = { silent = true } })
end, { nargs = 1, bang = true })

vim.api.nvim_create_user_command("Words", function (args)
	vim.cmd[args.bang and "vimgrepadd" or "vimgrep"]({ args = { string.format([[/\<%s\>/gj]], args.args), "**/*" }, mods = { silent = true } })
end, { nargs = 1 })

vim.api.nvim_create_user_command("Find", function(args)
	finder:find(args.args)
end, { nargs = 1})
vim.o.quickfixtextfunc = "v:lua.require'quickfix.textfunc'.func"

autocmd("QuickFixCmdPost", {
	group = qf,
	nested = true,
	callback = function()
		if vim.tbl_isempty(vim.fn.getqflist()) then
			return
		end

		vim.cmd.copen()
	end
})

local Linter = require "linter"

vim.api.nvim_create_user_command("Lint", function(args)
	Linter(args.fargs, args.bang, vim.api.nvim_get_current_win())
end, {
	nargs = "*",
	bang = true,
})

vim.api.nvim_create_user_command("Clint", function(args)
	Linter(args.fargs, args.bang)
end, {
	nargs = "*",
	bang = true,
})

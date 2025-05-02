vim.api.nvim_create_user_command(
	"Vimgrep",
	function(args)
		vim.cmd[args.bang and "vimgrepadd" or "vimgrep"]({ args = { string.format([[/\v%s/gj]], args.args), "**/*" }, mods = { silent = true } })
	end,
	{
		nargs = 1,
		bang = true,
		desc = [[A vimgrep, but default use \v very magic for regexp.]]
	})

vim.api.nvim_create_user_command(
	"Vimwords",
	function(args)
		pcall(vim.cmd[args.bang and "vimgrepadd" or "vimgrep"], { args = { string.format([[/\<%s\>/gj]], args.args), "**/*" }, mods = { silent = true } })
	end, {
		nargs = 1,
		bang = true,
		desc = [[A vimgrep pattern word, argument must be `iskeyword`, but default use \v very magic for regexp.]]
	})

vim.api.nvim_create_user_command(
	"Lvimwords",
	function(args)
		vim.cmd[args.bang and "vimgrepadd" or "vimgrep"]({ args = { string.format([[/\v<%s>/gj]], args.args), "**/*" }, mods = { silent = true } })
	end, {
		nargs = 1,
		bang = true,
		desc = [[A vimgrep pattern word, argument must be `iskeyword`, but default use \v very magic for regexp.]]
	})

vim.api.nvim_create_user_command(
	"Lvimwords",
	function(args)
		vim.cmd[args.bang and "vimgrepadd" or "vimgrep"]({ args = { string.format([[/\v<%s>/gj]], args.args), "**/*" }, mods = { silent = true } })
	end, {
		nargs = 1,
		bang = true,
		desc = [[A vimgrep pattern word, argument must be `iskeyword`, but default use \v very magic for regexp.]]
	})

vim.api.nvim_create_user_command("Find",
	function(args)
		require "finder".find(args.args)
	end,
	{
		nargs = 1,
		desc = "Find file by name. using the external gnu find."
	})


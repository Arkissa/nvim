if not vim.fn.executable("cgrep") then
	return
end

local Cgrep = require "quickfix.cgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.api.nvim_create_user_command("Cgrep", function(args)
	vim.opt.grepprg = Cgrep()
	vim.cmd.grep({ args = args.fargs, mods = { silent = true }, bang = not args.bang })
end, {
	nargs = '*',
	bang = true,
	complete = function()
		return {
			"-c",
			"--code",
			"-m",
			"--comment",
			"-l",
			"--literal",
			"--name",
			"--identifier",
			"--type",
			"--native",
			"--keyword",
			"--number",
			"--string",
			"--op",
			"-S",
			"--semantic",
			"--max-count=",
			"-t",
			"--type-filter=",
			"-k",
			"--kind-filter=",
			"--force-type=",
			"--type-list",
			"-v",
			"--invert-match",
			" --multiline=",
			"-r",
			"--recursive",
			"-T",
			"--skip-test",
			"--prune-dir=",
			"-L",
			"--follow",
			"--show-match",
			"--color",
			"--no-color",
			"-h",
			"--no-filename",
			"--no-numbers",
			"--no-column",
			"--count",
			"--filename-only",
			"--json",
			"--vim",
			"--editor",
			"--fileline",
			"-j",
			"--threads=",
			"--verbose=",
			"--no-shallow",
			"--palette",
			"-?",
			"--help",
			"-V",
			"--version",
			"--numeric-version",
		}
	end
})

vim.cmd.Alias({ args = {"grep", "Cgrep"}})

require "grep".create_command()
if vim.fn.getcwd() == vim.fn.stdpath("config") then
	vim.g.finder_exculd_dirs = { "pack" }
	vim.g.cgrep_exculd_dirs = { "pack" }
end

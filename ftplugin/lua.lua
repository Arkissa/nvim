if vim.fn.getcwd() == vim.fn.stdpath("config") then
	vim.g.find_exculd_dirs = { "pack" }
	vim.g.cgrep_exculd_dirs = { "pack" }
end

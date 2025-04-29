vim.opt_local.spell = true
vim.cmd.compiler("go")

local gopkg = vim.fs.joinpath(vim.fn.trim(vim.fn.system("go env GOPATH")), "pkg", "mod")
local goroot = vim.fs.joinpath(vim.fn.trim(vim.fn.system("go env GOROOT")), "src")
vim.g.under_path(function(path)
	return vim.fs.relpath(goroot, path)
		or vim.fs.relpath(gopkg, path)
end)

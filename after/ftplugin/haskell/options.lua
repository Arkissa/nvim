local opt = vim.opt_local
local buffer = Buffer(vim.api.nvim_get_current_buf())
opt.listchars:append { lead = "∙" }
opt.list = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

vim.api.nvim_buf_create_user_command(buffer:bufnr(), "Hlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs)
end, {
	nargs = "*"
})

vim.api.nvim_buf_create_user_command(buffer:bufnr(), "LHlint", function(opts)
	if not vim.fn.executable("hlint") then
		return vim.notify("Hlint: not found hlint command", vim.log.levels.ERROR)
	end

	require "haskell.hlint".hlint(opts.fargs, vim.api.nvim_get_current_win())
end, {
	nargs = "*"
})

local dir = Path.root(buffer:bufnr(), { 'stack.yaml', '*.cabal' })
if dir == nil then
	return
end

local joinpath = vim.fs.joinpath

if vim.uv.fs_stat(joinpath(dir, "stack.yaml")) then
	buffer:set_var("start", "stack repl --ghci-options '-v0' %")
elseif vim.uv.fs_stat(vim.fn.glob(joinpath(dir, "*.cabal"))) then
	buffer:set_var("start", "cabal repl --repl-options='-v0' %")
end


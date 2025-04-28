local opt = vim.opt_local
local buffer = Buffer(vim.api.nvim_get_current_buf())
opt.listchars:append { lead = "∙" }
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.commentstring = '-- %s'

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


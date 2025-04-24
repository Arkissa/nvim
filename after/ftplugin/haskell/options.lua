local opt = vim.opt_local
local buffer = Buffer(vim.api.nvim_get_current_buf())
opt.listchars:append { lead = "∙" }
opt.list = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
autocmd("LspAttach", {
	group = augroup("haskell", {}),
	buffer = buffer:bufnr(),
	callback = function ()
		vim.lsp.inlay_hint.enable(false)
	end
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


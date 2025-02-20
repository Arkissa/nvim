vim.loader.enable()

_G.augroup = vim.api.nvim_create_augroup
_G.autocmd = vim.api.nvim_create_autocmd

vim.g.markdown_syntax_conceal = 2
vim.g.kastemds_path = "~/kastemd"

vim.cmd.packadd "cfilter"

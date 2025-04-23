vim.loader.enable()

vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
vim.g.loaded_node_provider = false
vim.g.loaded_python3_provider = false

_G.augroup = vim.api.nvim_create_augroup
_G.autocmd = vim.api.nvim_create_autocmd
_G.Buffer = require "buffers"
_G.Path = require "path"

vim.cmd.packadd "cfilter"

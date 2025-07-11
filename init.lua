vim.loader.enable()

vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
vim.g.loaded_node_provider = false
vim.g.loaded_python3_provider = false

Augroup = vim.api.nvim_create_augroup
Autocmd = vim.api.nvim_create_autocmd
Buffer = require "buffers"
Path = require "path"
Colors = require "colors"
Set = require "set"
vim.cmd.packadd "cfilter"

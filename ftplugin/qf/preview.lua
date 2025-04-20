local bufnr = vim.api.nvim_get_current_buf()
vim.bo[bufnr].buflisted = false
vim.opt_local.relativenumber = false
local winnr = vim.api.nvim_get_current_win()
vim.wo[winnr].list = false

vim.keymap.set('n', 'u', "<CMD>colder<CR>", { noremap = true, buffer = bufnr, silent = true, desc = "Quickfix list undo changed" })
vim.keymap.set('n', '<C-r>', "<CMD>cnewer<CR>", { noremap = true, buffer = bufnr, silent = true, desc = "Quickfix list redo changed" })

require "quickfix.preview".preview_on_float(vim.api.nvim_get_current_win())

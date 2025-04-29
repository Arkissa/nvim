local Haskell = require "haskell"
Haskell.set_start(Buffer(vim.api.nvim_get_current_buf()), { 'stack.yaml', '*.cabal' })

vim.cmd.compiler("cabal")

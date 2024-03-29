return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        require 'gitsigns'.setup {
            signs = {
                add          = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
                change       = {
                    hl = 'GitSignsChange',
                    text = '░',
                    numhl = 'GitSignsChangeNr',
                    linehl = 'GitSignsChangeLn'
                },
                delete       = {
                    hl = 'GitSignsDelete',
                    text = '_',
                    numhl = 'GitSignsDeleteNr',
                    linehl = 'GitSignsDeleteLn'
                },
                topdelete    = {
                    hl = 'GitSignsDelete',
                    text = '▔',
                    numhl = 'GitSignsDeleteNr',
                    linehl = 'GitSignsDeleteLn'
                },
                changedelete = {
                    hl = 'GitSignsChange',
                    text = '▒',
                    numhl = 'GitSignsChangeNr',
                    linehl = 'GitSignsChangeLn'
                },
                untracked    = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim
                        .keymap
                        .set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                -- Actions
                map('v', '<leader>ui', ':Gitsigns stage_hunk<CR>')
                map('n', '<leader>uh', gs.undo_stage_hunk)
                map('n', '<leader>ua', function() gs.blame_line { full = true } end)
                map('n', '<leader>tb', gs.toggle_current_line_blame)
                map('n', '<leader>ud', gs.diffthis)
            end
        }
    end
}

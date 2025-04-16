require "oil".setup {
	columns = {
		"mtime",
		"size",
		"icon",
	},
	keymaps = {
		["<C-s>"] = { "actions.select", opts = { vertical = true, split = "belowright" } },
		["<C-k>"] = "actions.open_terminal"
	},
	float = {
		-- Padding around the floating window
		padding = 2,
		max_width = 100,
		max_height = 20,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
		get_win_title = nil,
		-- preview_split: Split direction: "auto", "left", "right", "above", "below".
		preview_split = "auto",
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
}
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

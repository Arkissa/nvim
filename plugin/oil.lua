require "oil".setup {
	columns = {
		"mtime",
		"size",
		"icon",
	},
	keymaps = {
		["<C-s>"] = { "actions.select", opts = { vertical = true, split = "belowright" } },
	},
}
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<LEADER>-", "<CMD>vsplit | Oil<CR>", { desc = "Open parent vsplit directory" })

require 'nvim-treesitter.configs'.setup {
	modules = {},
	ignore_install = {},
	ensure_installed = {
		"c",
		"rust",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"python",
		"go",
		"gomod",
		"luadoc",
		"regex",
		"make",
		"printf",
		"http",
		"html",
		"sql",
		"nix",
		"haskell",
		"yaml",
		"toml",
		"proto",
		"sql",
		"json",
		"bash",
		"gitcommit",
	},

	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		-- disable = { 'markdown' },
		-- additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'vin',
			-- below are vmap
			node_incremental = 'vik',
			node_decremental = 'vij',
		},
	},
	indent = {
		enable = true,
	},
}

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
		"haskell",
		"make",
		"printf",
		"http",
		"html",
		"sql",
		"nix",
		"yaml",
		"toml",
		"proto",
		"sql",
		"json",
		"bash",
		"gitcommit",
	},

	sync_install = false,
	-- auto_install = true,

	highlight = {
		enable = true,
		disable = { 'haskell' },
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
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["[f"] = "@function.outer"
			},
			goto_previous_start = {
				["]f"] = "@function.outer"
			}
		}
	}
}

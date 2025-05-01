require "catppuccin".setup {
	flavour = "mocha",
	transparent_background = true,
}

Colors = require "catppuccin.palettes".get_palette("mocha")
vim.cmd.colorscheme "catppuccin"

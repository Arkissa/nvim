local opt = vim.opt
local opt_local = vim.opt_local
local k = vim.keycode
local g = vim.g

opt.number = true
opt.filetype.plugin = true
opt.filetype.indent = true
opt.autoindent = true
opt.smartindent = true
opt.undofile = true
opt.ruler = false
opt.spelllang:append "cjk"
opt_local.cursorline = true
opt.autowrite = true
opt.showmode = false
-- opt.cmdheight = 0
opt.fillchars = {
	fold = "-",
	eob = " ",
	lastline = "@",
}
opt.list = true
opt.showbreak = "↪ "
opt.listchars = {
	-- tab = '› ',
	tab = '│ ',
	trail = '·',
}
opt.shiftwidth = 4
opt.softtabstop = 4
opt.signcolumn = "yes"
opt.tabstop = 4
opt.scrolloff = 60
opt.laststatus = 3
opt.smartcase = true
opt.ignorecase = true
opt.wildmenu = true
opt.mouse = ""
opt.shortmess:append "c"
vim.opt.wildignore:append {
	'*.o',
	'**/dist-newstyle/**',
	'*.ibc',
	'*.pyc',
	'__pycache__',
	'node_modules/',
	'*.a',
	'*.hi',
	'*.spl',
	'.DS_Store',
	'**/.git/**',
	'**/pack/**',
	'**/bin/**',
}

g.mapleader = k'<SPACE>'

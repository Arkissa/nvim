local opt = vim.opt
local k = vim.keycode
local g = vim.g

opt.number = true
opt.filetype.plugin = true
opt.filetype.indent = true
opt.autoindent = true
opt.smartindent = true
opt.backup = true
opt.backupdir:remove(".")
opt.undofile = true
opt.ruler = false
opt.spelllang:append "cjk"
opt.autowrite = true
opt.showmode = false
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
opt.signcolumn = "yes:1"
opt.tabstop = 4
opt.scrolloff = 60
opt.laststatus = 3
opt.smartcase = true
opt.ignorecase = true
opt.wildmenu = true
opt.mouse = ""
opt.numberwidth = 2
opt.shortmess:append "c"
opt.winborder = "rounded"
opt.pumheight = 15
vim.opt.wildignore:append {
	'*.o',
	'*.ibc',
	'*.pyc',
	'*.a',
	'*.hi',
	'*.spl',
	'.DS_Store',
	'**/__pycache__/**',
	'**/dist-newstyle/**',
	'**/node_modules/**',
	'**/.git/**',
	'**/pack/**',
	'**/bin/**',
}

g.mapleader = k'<SPACE>'

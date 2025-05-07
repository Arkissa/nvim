vim.o.quickfixtextfunc = "v:lua.require'quickfix.textfunc'.func"

Autocmd("QuickFixCmdPost", {
	pattern = {
		"make",
		"grep",
		"grepadd",
		"vimgrep",
		"vimgrepadd",
		"helpgrep",
		"cfile",
		"cgetfile",
		"caddfile",
		"cexpr",
		"cgetexpr",
		"caddexpr",
		"cbuffer",
		"cgetbuffer",
		"caddbuffer"
	},
	command = "cwindow",
})

Autocmd("QuickFixCmdPost", {
	pattern = {
		"lmake",
		"lgrep",
		"lgrepadd",
		"lvimgrep",
		"lvimgrepadd",
		"lfile",
		"lgetfile",
		"laddfile",
		"lhelpgrep",
		"lexpr",
		"lgetexpr",
		"laddexpr",
		"lbuffer",
		"lgetbuffer",
		"laddbuffer"
	},
	command = "lwindow"
})

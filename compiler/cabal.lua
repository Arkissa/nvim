vim.b.current_compiler = "cabal"

local opt = vim.opt_local

local efm = {
	[[%-G]],
	[[%E%f:%l:%c:\ error:]],
	[[%+Z\ \ \ \ %m]],
	[[%E%f:%l:%c:\ error:\ %m]],
	[[%-Z]],
	[[%W%f:%l:%c:\ warning:]],
	[[%+Z\ \ \ \ %m]],
	[[%W%f:%l:%c:\ warning:\ %m]],
	[[%-Z]]
}

opt.errorformat=vim.iter(efm):join(',')

opt.makeprg = "cabal"

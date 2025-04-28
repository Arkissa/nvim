if not vim.fn.executable("cgrep") then
	return
end

local cgrep = {
	"cgrep",
	"-r",
}

local default_exculd_dirs = {
	".git/",
	"__pycache__/",
	"dist-newstyle/",
	"node_modules/",
}

local prune_dir = vim.iter({default_exculd_dirs, vim.g.cgrep_exculd_dirs or {}})
	:flatten()
	:map(function(dir)
		return "--prune-dir=" .. dir
	end)
	:totable()

local kind_filter = vim.iter(vim.g.cgrep_kind_filter or {})
	:map(function(dir)
		return "--kind-fiters=" .. dir
	end)
	:totable()

local type_filter = vim.iter(vim.g.cgrep_type_filter or {})
	:map(function(dir)
		return "--type-filter=" .. dir
	end)
	:totable()

vim.opt.grepprg = vim.iter({ cgrep, prune_dir, kind_filter, type_filter }):flatten():join(' ') .. " $* ."
vim.opt.grepformat = "%-G,%f:%l:%c:%m"

if vim.fn.exists(":Grep") == 0 then
	return
end

vim.cmd.Alias({ args = {"grep", "Grep"}})

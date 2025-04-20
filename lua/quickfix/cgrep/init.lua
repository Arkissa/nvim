---@alias Cgrep string

---@class CgrepMod
---@operator call: Cgrep


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

return setmetatable({}, {
	__call = function(_)
		local prune_dir = vim.iter(vim.fn.extendnew(default_exculd_dirs, vim.g.cgrep_exculd_dirs or {}))
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

		return vim.iter({ cgrep, prune_dir, kind_filter, type_filter }):flatten():join(' ') .. " $* ."
	end
}) --[[@as CgrepMod]]

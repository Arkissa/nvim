---@param iter Iterator
---@return table<string>
local function collect(iter)
	local t = {}
	for x in iter do
		table.insert(t, x)
	end

	return t
end

local lsps = vim.iter(collect(vim.fs.dir(vim.fn.stdpath("config") .. "/lsp")))
	:map(function(filename)
		local i = filename:find("%.[^%.]*$")
		return filename:sub(1, i-1)
	end)
	:filter(function(name)
		return vim.fn.executable(vim.lsp.config[name].cmd[1]) == 1
	end)
	:totable()

vim.lsp.enable(lsps)

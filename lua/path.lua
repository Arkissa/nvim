local M = {}
M.__index = M

---@param source integer|string
---@param marker string|string[]
---@return string?
function M.root(source, marker)
	local fname
	if type(source) == "string" then
		fname = source
	else
		fname = Buffer(source):name()
	end

	local paths = vim.iter({marker})
		:flatten()
		:totable()

	for dir in vim.fs.parents(fname) do
		for _, path in ipairs(paths) do
			path = vim.fn.glob(vim.fs.joinpath(dir, path))
			if vim.uv.fs_stat(path) then
				return dir
			end
		end
	end

	return nil
end

return M

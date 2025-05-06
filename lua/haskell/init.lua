local M = {}
M.__index = M

M.root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" }

---@param buffer buffers.Buffer
---@param root_markers string[]
function M.set_start(buffer, root_markers)
	local dir = M.get_root(buffer:bufnr(), root_markers)
	if dir == nil then
		return
	end

	local joinpath = vim.fs.joinpath

	if vim.uv.fs_stat(joinpath(dir, "stack.yaml")) then
		buffer:set_var("start", "stack repl --ghci-options '-v0' %")
	elseif vim.uv.fs_stat(vim.fn.glob(joinpath(dir, "*.cabal"))) then
		buffer:set_var("start", "cabal repl --repl-options='-v0' %")
	end
end

---@param bufnr integer?
---@param root_markers string[]?
---@return string?
function M.get_root(bufnr, root_markers)
	return Path.root(bufnr or 0, root_markers or M.root_markers)
end

---@param bufnr integer
function M.edit_project_cabal(bufnr)
	local dir = Path.root(bufnr, M.root_markers)
	if dir == nil then
		vim.notify("Haskell: Not found workspace dir.", vim.log.levels.ERROR)
		return
	end

	local cabals = vim.split(vim.fn.glob(vim.fs.joinpath(dir, "*.cabal")), '\n', {trimempty = true})
	if vim.tbl_isempty(cabals) then
		vim.notify("Haskell: Not found *.cabal file.", vim.log.levels.ERROR)
		return
	end

	vim.cmd('e ' .. cabals[1])
end

return setmetatable({}, M)

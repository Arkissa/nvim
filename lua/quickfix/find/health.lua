local M = {}

local n = {
	"Please to install GNU find"
}

function M.check()
	vim.health.start("Find (optional)")
	if not vim.fn.executable("find") then
		return vim.health.warn("GNU find was not found", n)
	end

	local result = vim.system({"find", "--version"}, { text = true }):wait()
	if result.code ~= 0 or not result.stdout or result.stdout:match("GNU") == nil then
		return vim.health.warn("This find not is GNU find", n)
	end

	local version = vim.split(result.stdout, '\n', { trimempty = true })[1]
	vim.health.ok("find version: ".. version:match("[0-9].[0-9].[0-9]"))
end

return M

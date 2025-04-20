local M = {}

local n = {
	"cabal install cgrep.",
	"stack install cgrep.",
	"or else use package manager to install cgrep.",
}

function M.check()
	vim.health.start("Cgrep (optional)")
	if not vim.fn.executable("cgrep") then
		return vim.health.warn("cgrep was not found", n)
	end

	local result = vim.system({"cgrep", "--numeric-version"}, { text = true }):wait()
	if result.code ~= 0 or not result.stdout then
		return vim.health.warn("The cgrep not is https://awgn.github.io/cgrep.", n)
	end

	if result.stdout:match([[8.[0-9].[0-9].]]) == nil then
		return vim.health.warn("cgrep version must be >=8.0.0.")
	end

	vim.health.ok("cgrep version: "..result.stdout)
end

return M

local M = {}

---@param cmd string[]
---@return string|nil
local function system(cmd)
	local result = vim.system(cmd, {text = true}):wait()
	if result.code ~= 0 or result.stdout == "" then
		return nil
	end

	return result.stdout
end


---@type {name: string, check: fun(): {level: string, title: string, msg: string}[]}[]
local healths = {
	{
		name = "Find (optional)",
		check = function()
			local msg = "Please Install GNU find"
			if not vim.fn.executable("find") then
				return {{level = "warn", title = "GNU find was not found", msg = msg}}
			end

			local result = system({ "find", "--version" })
			if not result or result:match("GNU") == nil then
				return {{level = "warn", title = "This find not is GNU find", msg = msg}}
			end

			local version = vim.split(result, '\n', { trimempty = true })[1]
			return {{level = "ok", title = "find version: " .. version:match("[0-9].[0-9].[0-9]"), msg = "" }}
		end
	},
	{
		name = "Cgrep (optional)",
		check = function ()
			local msg = {}
			if vim.fn.executable("cabal")  then
				table.insert(msg, "cabal install cgrep")
			end

			if vim.fn.executable("stack") then
				table.insert(msg, "stack install cgrep")
			end

			if not vim.fn.executable("cgrep") then
				return {{level = "warn", title = "cgrep was not found", msg = vim.iter(msg):join("or")}}
			end

			local result = system({"cgrep", "--numeric-version"})
			if not result or result:match([[8.[0-9]+.[0-9]+.]]) == nil then
				return {{level = "warn", title = "cgrep must be >= 8.0.0.", msg = vim.iter(msg):join("or")}}
			end

			return {{level = "ok", title = "Cgrep version: " .. vim.trim(result), msg = ""}}
		end
	},
	{
		name = "Haskell dev (optional)",
		check = function ()
			local results = {}
			local ghcup = [[Install ghcup and install it.
`curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh`]]
			if vim.fn.executable("ghcup") then
				ghcup = "only needed for ghcup install"
			end

			if not vim.fn.executable("ghc") then
				table.insert(results, {level = "warn", title = "ghc was not found", msg = ghcup})
			else
				local result = assert(system({"ghc", "--version"}))
				table.insert(results, {level = "ok", title = "GHC version: " .. vim.trim(result)})
			end

			if not vim.fn.executable("cabal") then
				table.insert(results, {level = "warn", title = "cabal was not found", msg = ghcup})
			else
				local result = assert(system({"cabal", "--version"}))
				table.insert(results, {level = "ok", title = "Cabal version: " .. vim.trim(result)})
			end

			if not vim.fn.executable("stack") then
				table.insert(results, {level = "warn", title = "stack was not found", msg = ghcup})
			else
				local result = assert(system({"stack", "--version"}))
				table.insert(results, {level = "ok", title = "Stack version: " .. vim.trim(result)})
			end

			if not vim.fn.executable("haskell-language-server-wrapper") then
				table.insert(results, {level = "warn", title = "haskell-language-server-wrapper was not found", msg = ghcup})
			else
				local result = assert(system({"haskell-language-server-wrapper", "--version"}))
				table.insert(results, {level = "ok", title = "HLS version: " .. vim.trim(result)})
			end

			return results
		end
	}
}

function M.check()
	for _, health in ipairs(healths) do
		vim.health.start(health.name)
		local results = health.check()
		for _, result in ipairs(results) do
			vim.health[result.level](result.title, result.msg)
		end
	end
end

return M

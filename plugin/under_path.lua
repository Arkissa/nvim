local function fail()
	vim.notify("exists('+clipboard') is "..tostring(vim.fn.exists('+clipboard')).." can't using clipboard.")
end

---@param f function
---@return function
local function fail_wrap(f)
	if vim.fn.exists("+clipboard") ~= 0 then
		return f
	end

	return fail
end

---@param str string
local function copy_to_clipbard(str)
	vim.fn.setreg("+", str)
	vim.fn.setreg("*", str)
end

-- This for set breakpoint on terminal debugger, very very useful.
---@type fun(real_path: fun(path: string): string|nil)
vim.g.under_path = function(real_path)
	local bufnr = vim.api.nvim_get_current_buf()

	---@param path string
	---@return string|nil
	local function project_root(path)
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		if vim.tbl_isempty(clients) then
			return nil
		end

		return vim.fs.relpath(clients[1].root_dir, path)
	end

	---@param path string
	---@return string
	local function get_file(path)
		local file = project_root(path)
		if file == nil and type(real_path) == "function" then
			file = real_path(path)
		end

		if file == nil then
			file = vim.fs.basename(path)
		end

		return file
	end

	vim.keymap.set("o", "il",
		fail_wrap(function()
			if vim.v.operator ~= 'y' then
				return
			end

			local file = get_file(vim.fn.expand("%:p"))
			copy_to_clipbard(("%s:%d"):format(file, vim.fn.line(".")))
		end),
		{
			buffer = bufnr,
			desc = "copy project relative path and line of under the cursor to clipboard.",
		})

	vim.keymap.set("o", "al",
		fail_wrap(function()
			if vim.v.operator ~= 'y' then
				return
			end

			local file = vim.fn.expand("%:p")
			copy_to_clipbard(("%s:%d"):format(file, vim.fn.line(".")))
		end),
		{
			buffer = bufnr,
			desc = "copy abspath and line of under the cursor to clipboard."
		})
end

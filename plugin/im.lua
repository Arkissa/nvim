if not vim.fn.executable("ibus") then
	return
end

---@type string
local last_mode = ""

autocmd("ModeChanged", {
	pattern = "i:n",
	callback = function ()
		local object = vim.system({ "ibus", "engine" }):wait()
		if object.code ~= 0 then
			return
		end

		local mode = vim.trim(object.stdout)

		last_mode = mode
		if  mode ~= "xkb:us::eng" then
			vim.system({ "ibus", "engine", "xkb:us::eng" }):wait()
		end
	end
})

autocmd("ModeChanged", {
	pattern = "n:i",
	callback = function ()
		if last_mode ~= "" then
			vim.system({ "ibus", "engine", last_mode }):wait()
		end
	end
})

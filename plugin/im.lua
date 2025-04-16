if not vim.fn.executable("ibus") then
	return
end

autocmd("ModeChanged", {
	pattern = "i:n",
	callback = function ()
		local object = vim.system({ "ibus", "engine" }):wait()
		if object.code ~= 0 then
			return
		end

		if vim.trim(object.stdout) == "rime" then
			vim.system({ "ibus", "engine", "xkb:us::eng" }):wait()
		end
	end
})

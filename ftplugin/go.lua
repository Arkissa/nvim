local goroup = augroup("goroup", { clear = false })

autocmd("BufWritePre", {
	desc = "format .go file on save",
	callback = function()
		local params = vim.lsp.util.make_range_params(0, "utf-8")
		---@diagnostic disable-next-line: inject-field
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, vim.lsp.protocol.Methods.textDocument_codeAction, params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format()
	end
})

-- This for set breakpoint on dlv, very very useful.
if vim.fn.exists('+clipboard') then
	autocmd("LspAttach", {
		desc = "Copy the file path of cursor under the line in .go file",
		group = goroup,
		callback = function(args)
			local gopath = vim.fs.joinpath(vim.fn.trim(vim.fn.system("go env GOPATH")), "pkg", "mod")
			local goroot = vim.fs.joinpath(vim.fn.trim(vim.fn.system("go env GOROOT")), "src")

			vim.keymap.set("o", "ll", function()
				if vim.v.operator ~= 'y' then
					return
				end

				local raw = vim.fn.expand("%")
				local file = vim.fs.relpath(goroot, raw) or vim.fs.relpath(gopath, raw) or raw

				vim.fn.setreg("+", string.format("%s:%d", file, vim.fn.line(".")))
			end, { buffer = args.buf })
		end
	})
end

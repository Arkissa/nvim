local methods = vim.lsp.protocol.Methods
local set = vim.keymap.set
local lsp = vim.lsp.buf
---@type ({menu: string, kind: string, kind_hlgroup: string})[]
local kind_icon = {
	{ menu = 'Text', kind = '󰦨', kind_hlgroup = 'String' },
	{ menu = 'Method', kind = '', kind_hlgroup = 'Function' },
	{ menu = 'Function', kind = '󰡱', kind_hlgroup = 'Function' },
	{ menu = 'Constructor', kind = '', kind_hlgroup = 'Function' },
	{ menu = 'Field', kind = '', kind_hlgroup = '@lsp.type.property' },
	{ menu = 'Variable', kind = '', kind_hlgroup = '@variable' },
	{ menu = 'Class', kind = '', kind_hlgroup = 'Include' },
	{ menu = 'Interface', kind = '', kind_hlgroup = 'Type' },
	{ menu = 'Module', kind = '', kind_hlgroup = 'Exception' },
	{ menu = 'Property', kind = '', kind_hlgroup = '@lsp.type.property' },
	{ menu = 'Unit', kind = '󰊱', kind_hlgroup = 'Number' },
	{ menu = 'Value', kind = '', kind_hlgroup = '@variable' },
	{ menu = 'Enum', kind = '', kind_hlgroup = 'Number' },
	{ menu = 'Keyword', kind = '', kind_hlgroup = 'Keyword' },
	{ menu = 'Snippet', kind = '', kind_hlgroup = 'Keyword' },
	{ menu = 'Color', kind = '', kind_hlgroup = 'Keyword' },
	{ menu = 'File', kind = '', kind_hlgroup = 'Tag' },
	{ menu = 'Reference', kind = '', kind_hlgroup = 'Function' },
	{ menu = 'Folder', kind = '󰣞', kind_hlgroup = 'Function' },
	{ menu = 'EnumMember', kind = '', kind_hlgroup = 'Number' },
	{ menu = 'Constant', kind = '', kind_hlgroup = 'Constant' },
	{ menu = 'Struct', kind = '', kind_hlgroup = 'Type' },
	{ menu = 'Event', kind = '', kind_hlgroup = 'Constant' },
	{ menu = 'Operator', kind = '', kind_hlgroup = 'Operator' },
	{ menu = 'TypeParameter', kind = '', kind_hlgroup = 'Type' },
}

vim.lsp.config('*', {
	on_attach = function(client, bufnr)
		if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
			local id = Augroup("doc.highlight", { clear = false })
			Autocmd({ 'CursorHold', 'CursorHoldI' }, {
				group = id,
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight
			})
			Autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				group = id,
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references
			})
		end

		local opts = { noremap = true, silent = true, buffer = bufnr }
		if client:supports_method(methods.textDocument_rename) then
			set("n", "<LEADER>r", lsp.rename, opts)
		end

		if client:supports_method(methods.textDocument_codeAction) then
			set({ "n", "x" }, "<LEADER>a", lsp.code_action, opts)
		end

		if client:supports_method(methods.textDocument_typeDefinition) then
			set("n", "gD", lsp.type_definition, opts)
		end

		if client:supports_method(methods.textDocument_references) then
			set("n", "g]", lsp.references, opts)
		end

		if client:supports_method(methods.textDocument_implementation) then
			set("n", "<LEADER>i", lsp.implementation, opts)
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
			vim.lsp.inlay_hint.enable()
		end

		if client:supports_method(methods.textDocument_completion) then
			local chars = client.server_capabilities.completionProvider.triggerCharacters
			if chars then
				for i = string.byte('a'), string.byte('z') do
					if not vim.list_contains(chars, string.char(i)) then
						table.insert(chars, string.char(i))
					end
				end

				for i = string.byte('A'), string.byte('Z') do
					if not vim.list_contains(chars, string.char(i)) then
						table.insert(chars, string.char(i))
					end
				end
			end
			vim.lsp.completion.enable(true, client.id, bufnr, {
				autotrigger = true,
				convert = function(item)
					local m = kind_icon[item.kind]
					return vim.tbl_extend('force', item, {
						abbr = item.label,
						kind = m.kind,
						menu = ("[%s]"):format(m.menu),
						kind_hlgroup = m.kind_hlgroup,
					})
				end
			})
		end
	end
} --[[@as vim.lsp.Config]])

local lsps = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
	:map(function(filename)
		filename = assert(vim.fs.basename(filename)):gsub("%.lua", "")
		return filename
	end)
	:filter(function(name)
		return vim.lsp.config[name] ~= nil and name ~= "*"
	end)
	:filter(function(name)
		return vim.fn.executable(vim.lsp.config[name].cmd[1]) == 1
	end)
	:totable()

vim.lsp.enable(lsps)

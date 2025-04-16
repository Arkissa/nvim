local auto_completion = augroup("auto_completion", {})
local methods = vim.lsp.protocol.Methods
local pumvisible = vim.fn.pumvisible
local feedkeys = vim.api.nvim_feedkeys

local shorcut = {
	path = vim.keycode "<C-F>",
	omnifunc = vim.keycode "<C-X><C-O>",
	keyword = vim.keycode "<C-N>"
}

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

-- autocmd("InsertCharPre", {
-- 	group = auto_completion,
-- 	desc = 'autcomplete path',
-- 	callback = function()
-- 		if vim.opt.filetype:get() == "oil"
-- 			or pumvisible() == 1
-- 			or vim.fn.state 'm' == 'm'
-- 		then
-- 			return
-- 		end
--
-- 		local char = vim.v.char
--
-- 		if char:match("[^%w.]") then
-- 			return
-- 		end
--
-- 		if vim.opt.omnifunc:get() == "" then
-- 			feedkeys(shorcut.keyword, "im", false)
-- 			return
-- 		end
--
-- 		feedkeys(shorcut.omnifunc, "im", false)
-- 	end
-- })

autocmd('LspAttach', {
	desc = 'autocomplete lsp',
	group = auto_completion,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or not client:supports_method(methods.textDocument_completion) then
			return
		end

		vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
			convert = function(item)
				local m = kind_icon[item.kind]
				return {
					abbr = item.label,
					kind = m.kind,
					kind_hlgroup = m.kind_hlgroup,
					-- abbr_hlgroup = "Tag"
				}
			end
		})
	end,
})

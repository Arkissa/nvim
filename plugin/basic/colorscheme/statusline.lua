local statusline = require 'lualine'

local conditions = {
	buffer_not_empty = function()
		return #vim.fn.expand('%:t') ~= 0
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
}

-- Config
local config = {
	theme = 'auto',
	options = {
		component_separators = '',
		section_separators = '',
		theme = {
			normal = { c = { fg = Colors.fg, bg = Colors.bg } },
			inactive = { c = { fg = Colors.fg, bg = Colors.bg } },
		},
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left { 'mode' }

ins_left { 'lsp_status' }

ins_left {
	'branch',
	icon = '',
	color = {
		fg = Colors.violet,
		gui = 'bold'
	},
}

ins_left {
	'diff',
	symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
	diff_color = {
		added = { fg = Colors.green },
		modified = { fg = Colors.orange },
		removed = { fg = Colors.red },
	},
	cond = conditions.hide_in_width,
}

ins_left {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	diagnostics_color = {
		error = { fg = Colors.red },
		warn = { fg = Colors.yellow },
		info = { fg = Colors.cyan },
	},
}

ins_left {
	function()
		return '%='
	end,
}

ins_left {
	'filename',
	cond = conditions.buffer_not_empty,
	color = { fg = Colors.lavender, gui = 'bold' },
}

ins_right { 'location' }

ins_right { 'progress', color = { fg = Colors.fg, gui = 'bold' } }

ins_right {
	fmt = string.upper,
	function()
		return vim.api.nvim_get_option_value('filetype', { buf = 0 })
	end,
	color = { fg = Colors.green, gui = 'bold' },
}

ins_right {
	'o:encoding',
	fmt = string.upper,
	cond = conditions.hide_in_width,
	color = { fg = Colors.green, gui = 'bold' },
}

ins_right {
	'fileformat',
	fmt = string.upper,
	icons_enabled = false,
	color = { fg = Colors.green, gui = 'bold' },
}

statusline.setup(config)

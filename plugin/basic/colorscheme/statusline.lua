local statusline = require 'lualine'

local colors = require "catppuccin.palettes".get_palette("mocha")
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	theme = 'auto',
	options = {
		component_separators = '',
		section_separators = '',
		theme = {
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
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

local mode_color = {
	n = colors.mauve,
	i = colors.pink,
	v = colors.maroon,
	['␖'] = colors.blue,
	V = colors.blue,
	c = colors.magenta,
	no = colors.red,
	s = colors.orange,
	S = colors.orange,
	['␓'] = colors.orange,
	ic = colors.lavender,
	R = colors.violet,
	Rv = colors.violet,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	['r?'] = colors.cyan,
	['!'] = colors.red,
	t = colors.red,
}

ins_left {
	function()
		return '▊'
	end,
	color = { fg = colors.blue, gui = 'bold' },
	padding = { left = 0, right = 1 },
}

-- ins_left {
-- 	function()
-- 		-- return ''
-- 		return ''
-- 	end,
-- 	color = function()
-- 		return { fg = mode_color[vim.fn.mode()] }
-- 	end,
-- 	-- padding = { right = 1, left = 0 },
-- }

ins_left { 'mode' }

ins_left {
	function()
		local msg = ''
		local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
		local clients = vim.lsp.get_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			---@diagnostic disable-next-line: undefined-field
			if vim.tbl_contains(client.config.filetypes, buf_ft) then
				return client.name
			end
		end
		return msg
	end,
	icon = ' LSP:',
	color = {
		fg = colors.lavender,
		gui = 'bold',
	},
}

ins_left {
	'branch',
	icon = '',
	color = {
		fg = colors.violet,
		gui = 'bold'
	},
}

ins_left {
	'diff',
	symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
}

ins_left {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.cyan },
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
	color = { fg = colors.lavender, gui = 'bold' },
}

ins_right { 'location' }

ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_right {
	fmt = string.upper,
	function()
		return vim.api.nvim_get_option_value('filetype', { buf = 0 })
	end,
	color = { fg = colors.green, gui = 'bold' },
}

ins_right {
	'o:encoding',
	fmt = string.upper,
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = 'bold' },
}

ins_right {
	'fileformat',
	fmt = string.upper,
	icons_enabled = false,
	color = { fg = colors.green, gui = 'bold' },
}

ins_right {
	function()
		return '▊'
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
}

statusline.setup(config)

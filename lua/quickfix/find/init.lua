---@class quickfix.FinderMod
---@operator call: quickfix.Finder

---@class quickfix.Finder
---@field job vim.SystemObj
local Finder = {}
Finder.__index = Finder
local Buffer = require "buffers"

local default_exculd_dirs = { ".git", "dist-newstyle" }
local find = { "find", "-L", ".", "-type", "f" }

---@return string[]
local function exculd_dirs(dirs)
	local edirs = vim.iter(dirs)
		:filter(function(dir)
			local b = not vim.tbl_contains(default_exculd_dirs, dir)
			print(b)
			return b
		end)
		:totable()

	return vim.iter({edirs, default_exculd_dirs})
		:flatten()
		:map(function (dir)
			return { "-not", "-path", ("*/%s/*"):format(dir) }
		end)
		:totable()
end

local function exculd_files(files)
	return vim.iter(files)
		:map(function (file)
			return { "-not", "-name", file }
		end)
		:totable()
end

local function on_stdout(_, data)
	if data == nil then
		return
	end

	local items = vim.iter(vim.split(data, '\n', { trimempty = true }))
		:map(function(file)
			local buffer = Buffer(file)
			local col, end_col = 1, 1
			local lnum, end_lnum = 1, 1
			if buffer:is_loaded() then
				lnum, col = unpack(buffer:last_pos())
				end_lnum, end_col = lnum, col
			end

			return {
				bufnr = buffer:bufnr(),
				col = col,
				end_col = end_col,
				end_lnum = end_lnum,
				lnum = lnum,
				nr = 0,
				text = vim.fs.basename(buffer:name()),
				valid = 1,
			}
		end)
		:totable()

	vim.fn.setqflist(items, 'a')
end

---@private
function Finder.build_cmd(pattern)
	local cmd = { find }
	if vim.g.finder_exculd_dirs then
		table.insert(cmd, exculd_dirs(vim.g.exculd_dirs))
	end

	if vim.g.finder_exculd_files then
		table.insert(cmd, exculd_files(vim.g.exculd_files))
	end

	table.insert(cmd, { "-iname", pattern, "-printf", "%P\n" })

	return vim.iter(cmd):flatten(2):totable()
end

function Finder:find(pattern)
	local title = ("Find %s"):format(pattern)
	vim.fn.setqflist({}, 'r', { title = title })

	local cmd = Finder.build_cmd(pattern)
	self.job = vim.system(cmd, {
		text = true,
		cwd = vim.fn.getcwd(),
		stdout = vim.schedule_wrap(on_stdout)
	},
	vim.schedule_wrap(function(out)
		if out.code ~= 0 then
			vim.notify(("%s code: %s err: %s"):format(title, out.code, out.stderr))
		else
			local qflist = vim.fn.getqflist()
			vim.notify(("%s done, found %d files."):format(title, #qflist))
		end
	end))
end

return setmetatable({}, {
	__call = function(_)
		return setmetatable({}, Finder)
	end
}) --[[@as quickfix.FinderMod]]

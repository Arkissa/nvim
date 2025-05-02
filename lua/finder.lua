---@class quickfix.Finder
local Finder = {}
Finder.__index = Finder

local Buffer = require "buffers"
local AsyncCMD = require "async.cmd"

local default_exculd_dirs = {
	".git/",
	"__pycache__/",
	"dist-newstyle/",
	"node_modules/",
}

local find = { "find", "-L", ".", "-type", "f" }

---@return string[]
local function exculd_dirs(dirs)
	local edirs = vim.iter(dirs)
		:filter(function(dir)
			return not vim.tbl_contains(default_exculd_dirs, dir)
		end)
		:totable()

	return vim.iter(vim.list_extend(edirs, default_exculd_dirs))
		:map(function (dir)
			return { "-not", "-path", ("*/%s/*"):format(dir) }
		end)
		:flatten()
		:totable()
end

local function exculd_files(files)
	return vim.iter(files)
		:map(function (file)
			return { "-not", "-name", file }
		end)
		:flatten()
		:totable()
end

---@private
function Finder.build_cmd(pattern)
	local cmd = vim.list_extend({}, find)
	if vim.g.finder_exculd_dirs then
		vim.list_extend(cmd, exculd_dirs(vim.g.finder_exculd_dirs))
	end

	if vim.g.finder_exculd_files then
		vim.list_extend(cmd, exculd_files(vim.g.finder_exculd_files))
	end

	return vim.list_extend(cmd, { "-iname", pattern })
end

function Finder.find(pattern)
	local title = ("Find %s"):format(pattern)
	vim.fn.setqflist({}, 'r')
	vim.fn.setqflist({}, 'r', { title = title })

	AsyncCMD.quickfix(Finder.build_cmd(pattern), {
		on_stdout = function(invoke, lines)
			local items = vim.iter(lines)
				:filter(function (file)
					return #file ~= 0
				end)
				:map(function (file)
					local buffer = Buffer(file)
					local item = buffer:to_qfitem()
					if item.text == "" then
						item.text = vim.fs.basename(buffer:name())
					end

					return item
				end)
				:totable()

			invoke(items, 'a')
		end,
		on_exit = function(qf)
			qf:window()
		end
	})
end

return setmetatable({}, Finder)

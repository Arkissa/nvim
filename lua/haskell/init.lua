local M = {}
M.__index = M

M.root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" }

return setmetatable({}, M)

-- Loads optional files from the active profile (~/.config/nvim/lua/profile).
local M = {}

M.dir = vim.fn.stdpath("config") .. "/lua/profile"

function M.exists(relative_path)
  return vim.uv.fs_stat(M.dir .. "/" .. relative_path) ~= nil
end

-- Returns the module's value, or nil when the profile has no such file.
function M.load(name)
  if M.exists(name .. ".lua") then
    return require("profile." .. name)
  end
end

return M

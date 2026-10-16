-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Winbar with the file path, only when 2 or more windows in the current tab
-- show different files that have the same name (for example two index.ts files).
local function update_duplicate_name_winbars()
  local wins = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))

  -- file name -> set of buffers that show a file with that name
  local bufs_by_name = {}
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local path = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buftype == "" and path ~= "" then
      local name = vim.fn.fnamemodify(path, ":t")
      bufs_by_name[name] = bufs_by_name[name] or {}
      bufs_by_name[name][buf] = true
    end
  end

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local path = vim.api.nvim_buf_get_name(buf)
    local name = path ~= "" and vim.fn.fnamemodify(path, ":t") or nil
    local is_duplicate = name and vim.bo[buf].buftype == "" and vim.tbl_count(bufs_by_name[name] or {}) > 1
    if is_duplicate then
      local relative = vim.fn.fnamemodify(path, ":~:.")
      vim.wo[win].winbar = " " .. relative:gsub("%%", "%%%%")
      vim.w[win].jb_duplicate_winbar = true
    elseif vim.w[win].jb_duplicate_winbar then
      -- Only clear a winbar that this function set.
      vim.wo[win].winbar = ""
      vim.w[win].jb_duplicate_winbar = nil
    end
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinClosed", "BufFilePost", "TabEnter" }, {
  group = vim.api.nvim_create_augroup("DuplicateNameWinbar", { clear = true }),
  callback = function()
    vim.schedule(update_duplicate_name_winbars)
  end,
})

-- Keep this at the bottom
require("config.profile").load("autocmds")

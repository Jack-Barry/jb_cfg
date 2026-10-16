-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set 'background' from macOS appearance before any plugin loads.
-- Without this, Catppuccin can load with one flavour, and auto-dark-mode or
-- the terminal color query switches it a moment later. Plugins that store
-- colors at startup (render-markdown, bufferline) then keep the old colors.
-- auto-dark-mode still handles appearance changes while Neovim runs.
if vim.fn.has("mac") == 1 then
  local result = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait()
  local is_dark = result.code == 0 and (result.stdout or ""):match("Dark") ~= nil
  vim.o.background = is_dark and "dark" or "light"
end

vim.g.mapleader = "\\"
vim.opt.syntax = "off" -- Use Treesitter and friends instead
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.visualbell = true
vim.opt.infercase = true
vim.opt.wildmode = "full"
vim.opt.formatoptions = "qrn1"

-- Copilot suggestions show as ghost text (accept with <Tab>),
-- not as items in the completion menu. So <CR> only accepts menu items.
vim.g.ai_cmp = false

-- Disable treesitter on large files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*" },
  callback = function()
    local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
    if filesize < 1024 * 1024 then
      return
    end

    vim.treesitter.stop()
  end,
})

-- auto-reload files when modified externally
-- https://neovim.discourse.group/t/a-lua-based-auto-refresh-buffers-when-they-change-on-disk-function/2482/4
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- always use CWD for neotree
vim.g.root_spec = { "cwd" }

-- autosave sessions to better support tmux resurrection
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave", "TabLeave" }, {
  group = vim.api.nvim_create_augroup("PersistenceAutoSave", { clear = true }),
  callback = function()
    local ok, persistence = pcall(require, "persistence")
    if ok then
      persistence.save()
    end
  end,
})

-- Visual word wrap in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 0 -- disable hard wrap
  end,
})

-- Keep this at the bottom
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
require("config.profile").load("options")

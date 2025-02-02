-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd([[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]])

-- Override basic Vim settings
vim.g.mapleader = "\\"
vim.opt.syntax = "off" -- Use Treesitter and friends instead

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

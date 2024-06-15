-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Skip over the closing pair in insert mode
vim.api.nvim_set_keymap("i", "<C-l>", [[<Esc>la]], { noremap = true, silent = true })

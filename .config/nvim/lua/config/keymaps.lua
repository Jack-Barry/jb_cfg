-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Skip over the closing pair in insert mode
vim.api.nvim_set_keymap("i", "<C-l>", [[<Esc>la]], { noremap = true, silent = true })

vim.keymap.set({ "n" }, "<leader>xa", function()
  local item = {
    filename = vim.fn.expand("%"),
    lnum = vim.fn.line("."),
    text = vim.fn.getline("."),
  }
  vim.fn.setqflist({}, "a", { items = { item } })
end, { desc = "Add current line to quickfix list" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<leader>xd", function()
      local qflist = vim.fn.getqflist()
      local lnum = vim.fn.line(".")
      table.remove(qflist, lnum)
      vim.fn.setqflist({}, " ", { items = qflist })
    end, { buffer = true, desc = "Delete entry under cursor from quickfix list" })
  end,
})

vim.keymap.set({ "n", "x" }, "/", "/\\v", { desc = "Search (very magic)" })

vim.keymap.set("x", "&", ":&&<CR>", { desc = "Repeat last substitute with its flags" })

vim.keymap.set("c", "%%", function()
  return vim.fn.getcmdtype() == ":" and vim.fn.expand("%:h") .. "/" or "%%"
end, { expr = true, desc = "Insert directory of current file" })

vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })

vim.keymap.set("n", "<leader>qx", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

vim.keymap.set("n", "<leader>fy", function()
  vim.fn.setreg("+", vim.fn.expand("%:."))
end, { desc = "Yank file path relative to CWD" })

-- Keep this at the bottom
require("config.profile").load("keymaps")

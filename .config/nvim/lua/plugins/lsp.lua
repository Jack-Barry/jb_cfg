vim.filetype.add({
  pattern = {
    [".*/.*%.svx"] = "markdown",
  },
})

return {
  "neovim/nvim-lspconfig",
  event = { "BufAdd", "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    inlay_hints = {
      enabled = false,
    },
  },
}

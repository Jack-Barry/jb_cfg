return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    opts.defaults["<leader>h"] = { name = "+hurl" }
  end,
}

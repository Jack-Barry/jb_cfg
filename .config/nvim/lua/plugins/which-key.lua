return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    table.insert(opts.spec[1], { "<leader>h", group = "hurl", icon = "" })
    table.insert(opts.spec[1], { "<leader>o", group = "obsidian", icon = "" })
  end,
}

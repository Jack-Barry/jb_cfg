return {
  "nvim-neotest/neotest",
  version = "5.19.0",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "marilari88/neotest-vitest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        vitestCommand = "npx vitest --coverage.enabled=false",
      },
    },
  },
  keys = {
    {
      "<leader>tC",
      function()
        require("neotest").output_panel.clear()
      end,
      desc = "Clear output panel",
    },
  },
}

return {
  "jellydn/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = "hurl",
  opts = {},
  keys = {
    -- Run API request
    { "<leader>ha", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
    { "<leader>hr", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
    { "<leader>he", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    { "<leader>ht", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
    { "<leader>hv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    -- Run Hurl request in visual mode
    { "<leader>hr", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
  },
}

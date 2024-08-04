return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n" },
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n" },
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n" },
    },
  },
}

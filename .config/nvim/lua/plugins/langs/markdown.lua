return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        icons = {
          "① ",
          "②   ",
          "③     ",
          "④       ",
          "⑤         ",
          "⑥           ",
        },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/lua/plugins/langs/markdown-preview.css")
    end,
  },
}

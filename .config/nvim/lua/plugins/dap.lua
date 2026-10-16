return {
  "rcarriga/nvim-dap-ui",
  opts = function()
    local halfScreenWidth = math.floor(vim.o.columns * 0.5)
    return {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.5 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
          },
          size = halfScreenWidth,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1.0 },
          },
          size = 10, -- height in lines
          position = "bottom",
        },
      },
    }
  end,
}

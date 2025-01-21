return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.cmd([[
          setlocal relativenumber
        ]])
        end,
      },
      {
        event = "neo_tree_popup_input_ready",
        handler = function()
          -- enter input popup with normal mode by default.
          vim.cmd("stopinsert")
        end,
      },
      {
        event = "neo_tree_popup_input_ready",
        ---@param args { bufnr: integer, winid: integer }
        handler = function(args)
          -- map <esc> to enter normal mode (by default closes prompt)
          -- don't forget `opts.buffer` to specify the buffer of the popup.
          vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
        end,
      },
    },
  },
}

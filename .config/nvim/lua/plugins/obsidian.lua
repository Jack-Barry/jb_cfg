local notes_dir = vim.env.JB_CFG_NOTES_DIR

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cond = notes_dir ~= nil and notes_dir ~= "",
  opts = {
    legacy_commands = false,
    ui = { enable = false },
    workspaces = {
      {
        name = vim.fs.basename(notes_dir or ""),
        path = notes_dir,
        overrides = {
          notes_subdir = "Zettelkasten",
          new_notes_location = "notes_subdir",
          daily_notes = { folder = "Journal" },
          frontmatter = { enabled = false },
          templates = { folder = "Templates" },
          note_id_func = function(title)
            return title
          end,
        },
      },
    },
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New Note" },
    { "<leader>oj", "<cmd>Obsidian today<CR>", desc = "New Journal Entry for Today" },
    { "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian" },
  },
}

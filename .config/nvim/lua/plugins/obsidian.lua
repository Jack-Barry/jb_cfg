return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function(_, opts)
    opts.ui = { enable = false }
    opts.workspaces = {
      {
        name = "Notes 2.0",
        path = "~/Nextcloud/Notes/Obsidian/Notes 2.0",
        overrides = {
          disable_frontmatter = true,
          notes_subdir = "Zettelkasten",
          new_notes_location = "notes_subdir",
          daily_notes = {
            folder = "Journal",
          },
          note_id_func = function(title)
            return title
          end,
        },
      },
    }
    opts.mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    }
  end,
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note" },
    { "<leader>oj", "<cmd>ObsidianToday<CR>", desc = "New Journal Entry for Today" },
  },
}

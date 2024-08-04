-- Default behavior for note_id_func
-- local makeZettlekastenId = function(title)
--   -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
--   -- In this case a note with the title 'My new note' will be given an ID that looks
--   -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
--   local suffix = ""
--   if title ~= nil then
--     -- If title is given, transform it into valid file name.
--     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
--   else
--     -- If title is nil, just add 4 random uppercase letters to the suffix.
--     for _ = 1, 4 do
--       suffix = suffix .. string.char(math.random(65, 90))
--     end
--   end
--   return tostring(os.time()) .. "-" .. suffix
-- end

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ui = { enable = false },
    workspaces = {
      {
        name = "Default",
        path = "~/Nextcloud/Notes/Obsidian/General",
      },
    },
    mappings = {
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
    },
    note_id_func = function(title)
      return title
    end,
  },
}

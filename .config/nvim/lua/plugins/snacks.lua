return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          actions = {
            show_in_finder = function(_, item)
              os.execute("open -R " .. item.file)
            end,
          },
          include = { ".github", ".gitignore", ".husky", ".npmrc" },
          win = {
            list = {
              wo = { relativenumber = true },
              keys = {
                ["F"] = {
                  "show_in_finder",
                  desc = "Show in Finder",
                },
              },
            },
          },
        },
      },
    },
  },
}

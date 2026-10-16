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
          include = {
            ".config",
            ".gitconfig",
            ".github",
            ".gitignore",
            ".husky",
            ".jb_cfg_utils",
            ".jb_cfg_profiles",
            ".markdownlint.jsonc",
            ".npmrc",
            ".prettierrc.json",
            ".tmux.conf",
            ".vimrc",
            ".zshenv",
            ".zshrc",
          },
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

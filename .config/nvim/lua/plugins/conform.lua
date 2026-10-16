return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters.prettier = {
      cwd = require("conform.util").root_file({
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.mjs",
        ".prettierrc.toml",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
        "package.json",
      }),
      args = { "--stdin-filepath", "$FILENAME", "--ignore-path", "''" },
    }
  end,
}

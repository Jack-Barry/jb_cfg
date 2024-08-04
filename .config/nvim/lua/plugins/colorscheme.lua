return {
  {
    "catppuccin",
    opts = function()
      local flavour = "latte"
      if vim.env.JB_PRESENTATION_MODE == "true" then
        flavour = "mocha"
      end

      return {
        flavour = flavour,
        transparent_background = true,
        color_overrides = {
          latte = {
            peach = "#ea5e0e",
            yellow = "#d38619",
          },
        },
        highlight_overrides = {
          latte = function(colors)
            -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/latte.lua
            local info_color = colors.teal
            local warn_color = colors.peach
            local error_color = colors.red
            local debug_color = colors.mauve
            local trace_color = colors.lavender
            local success_color = colors.green

            return {
              -- nvim-notify: https://github.com/rcarriga/nvim-notify?tab=readme-ov-file#highlights
              NotifyINFOBorder = { fg = info_color },
              NotifyINFOIcon = { fg = info_color },
              NotifyINFOTitle = { fg = info_color },

              NotifyWARNBorder = { fg = warn_color },
              NotifyWARNIcon = { fg = warn_color },
              NotifyWARNTitle = { fg = warn_color },

              NotifyERRORBorder = { fg = error_color },
              NotifyERRORIcon = { fg = error_color },
              NotifyERRORTitle = { fg = error_color },

              NotifyDEBUGBorder = { fg = debug_color },
              NotifyDEBUGIcon = { fg = debug_color },
              NotifyDEBUGTitle = { fg = debug_color },

              NotifyTRACEBorder = { fg = trace_color },
              NotifyTRACEIcon = { fg = trace_color },
              NotifyTRACETitle = { fg = trace_color },

              -- neotest: https://github.com/nvim-neotest/neotest/blob/32ff2ac21135a372a42b38ae131e531e64833bd3/lua/neotest/config/init.lua#L6-L22
              -- NeotestAdapterName = { fg = info_color },
              -- NeotestBorder = { fg = info_color },
              NeotestDir = { fg = info_color },
              -- NeotestExpandMarker = { fg = info_color },
              -- NeotestFailed = { fg = info_color },
              NeotestFile = { fg = info_color },
              -- NeotestFocused = { fg = info_color },
              -- NeotestIndent = { fg = info_color },
              -- NeotestMarked = { fg = info_color },
              NeotestNamespace = { fg = debug_color },
              NeotestPassed = { fg = success_color },
              NeotestRunning = { fg = warn_color },
              -- NeotestSkipped = { fg = info_color },
              -- NeotestTarget = { fg = info_color },
              -- NeotestTest = { fg = info_color },
              -- NeotestUnknown = { fg = info_color },
              -- NeotestWatching = { fg = info_color },
              -- NeotestWinSelect = { fg = info_color },
            }
          end,
        },
        integrations = {
          -- for now disable this because it looks wack on headers
          render_markdown = false,
        },
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

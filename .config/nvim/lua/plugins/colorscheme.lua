return {
  {
    "catppuccin",
    opts = {
      flavour = "latte",
      transparent_background = true,
      color_overrides = {
        latte = {
          peach = "#ea5e0e",
          yellow = "#d38619",
        },
      },
      highlight_overrides = {
        latte = function(colors)
          local info_color = colors.teal
          local warn_color = colors.peach
          local error_color = colors.red
          local debug_color = colors.mauve
          local trace_color = colors.lavender

          return {
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
          }
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

return {
  { "junegunn/fzf", build = "./install --bin" },
  {
    "fzf-lua",
    opts = {
      fzf_colors = true,
      grep = {
        rg_opts = "--sort-files --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*' -g '!{package-lock.json,yarn.lock}'",
      },
    },
  },
}

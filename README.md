# JB Config

This is a repo to store my preferred settings for tools on a dev machine.

## Basic Setup Notes

Run

```bash
curl https://raw.githubusercontent.com/Jack-Barry/jb_cfg/main/.jb_scripts/install.sh | /bin/bash
```

## Manual Stuff

There's some things that I don't want to be bothered with automating.

- If `markdown-preview.nvim` isn't playing nice, (just shows a pop-up with the
  Node.JS version) try running this to fix it:

  ```shell
  ~/.local/share/nvim/lazy/markdown-preview.nvim/app/install.sh
  ```

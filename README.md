# JB Config

This is a repo to store my preferred settings for tools on a dev machine.

## Installation

Run

```bash
curl https://raw.githubusercontent.com/Jack-Barry/jb_cfg/main/.jb_cfg_utils/scripts/install.sh | /bin/bash
```

### After Installation Succeeds

1. (Optional) Create `~/.zshenv_untracked` and set `JB_CFG_PROFILE` there _if_ the machine uses a profile other than `default`.
2. Open a new shell, then run `jbcfg_link_profile` to establish symlinks for your profile
   - **NOTE** This step is required any time you change the `JB_CFG_PROFILE` value
3. (Optional) On a work machine, run the command below, so public commits never use a work email:

   ```zsh
   jbcfg config user.email <PERSONAL_EMAIL_ADDRESS>
   ```

## How Does it Work?

- The base loads first, and the profile loads last, so profile values win.
  - **NOTE** `.zshenv`, `.zshrc`, Git and Neovim configs are the only things that support extension currently.
- Git and Neovim read from `~/.jb_cfg_profiles/current`, and zsh reads `JB_CFG_PROFILE_DIR` (`~/.jb_cfg_profiles/<PROFILE_NAME>`).
- Each profile directory for extending the config mirrors `$HOME` dir.

## Manual Stuff

There's some things that I don't want to be bothered with automating.

- If `markdown-preview.nvim` isn't playing nice, (just shows a pop-up with the
  Node.JS version) try running this to fix it:

  ```shell
  ~/.local/share/nvim/lazy/markdown-preview.nvim/app/install.sh
  ```

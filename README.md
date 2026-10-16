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

This repository is "bare" cloned to your user directory, so that the files under source control can live there, even though its `.git` directory lives inside of `.jb_cfg`.

After initial install, you can create a profile to extend this config inside a `.jb_cfg_profiles/<PROFILE_NAME>` that you can keep under source control on its own. This allows you to add features that may be specific to one context, like work, that you don't want landing in a public repository such as this one. This is so that you can have your cake and eat it too; one base config for your common personal settings, and an ability to extend that when you need to.

- The base loads first, and the profile loads last, so profile values win.
  - **NOTE** `.zshenv`, `.zshrc`, Git and Neovim configs are the only things that support extension currently.
- Each profile directory for extending the config mirrors `$HOME` dir.

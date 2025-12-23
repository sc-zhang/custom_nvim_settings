## Custom settings for neovim

### Usage
1. Clone to neovim configure folder
```bash
git clone https://github.com/sc-zhang/custom_nvim_settings.git ~/.config/nvim/lua/personal
```

2. Add the line below to ~/.config/nvim/init.lua to load these settings
```lua
require "personal"
```

### Details
- autocmds
    1. locate to last edit position when open file
- keymaps
    1. bind \<leader\>d to duplicate current line and move cursor to the same column of duplicated line
    2. avoid cursor move to left character after exit INSERT mode to NORMAL mode
- options
    1. turn on relative line numbers


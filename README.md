# .config

## General usage

Clone somewhere on your system, symlink/source from config files

# Neovim

$XDG_CONFIG_HOME/nvim/init.lua
```lua
vim.opt.rtp:append("{cloned_repo_placement}/nvim")

_G.localconfig = {
	rtp_paths = { "{cloned_repo_placement}/nvim" },
	lsp_config = {
		gopls_settings = {
			-- gopls custom settings
		},
	},
	-- gotests_template_dir = (gotests template directory, optional),
	-- gotests_template = (gotests template file, optional),
}

vim.cmd [[source {cloned_repo_placement}/nvim/init.lua]]
```

# Tmux

$XDG_CONFIG_HOME/tmux/tmux.conf
```
source {cloned_repo_placement}/tmux/tmux.conf
```

Check terminal tmux-265color support
```
infocmp -x tmux-256color
```

If not supported, install it via
```
{cloned_repo_placement}/tmux/install-tmux256color.sh
```

tmux-256color support sequence taken from https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95

# Kitty
$XDG_CONFIG_HOME/kitty/kitty.conf
```
include {cloned_repo_placement}/kitty/kitty.conf
```

vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false
vim.o.autoread = true
vim.o.ignorecase = true
vim.o.lazyredraw = true
vim.o.showmatch = true
vim.o.mat = 0
vim.o.expandtab = false
vim.o.smarttab = true
vim.o.smartindent = true
vim.g.noerrorbells = true
vim.g.novisualbell = true
vim.o.cmdheight = 1

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.breakindent = true

vim.g.nobackup = true
vim.g.nowb = true
vim.g.noswapfile = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'

vim.keymap.set('n', '<leader><leader>', '/', { silent = true })
vim.keymap.set('n', '<leader>sr', ':so ~/.config/nvim/init.lua<cr>', { silent = true })
vim.keymap.set('n', '<leader>ss', ':so %<cr>', { silent = true })

vim.g.netrw_winsize = 20
vim.g.netrw_keepdir = 1
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3

local silent = { silent = true }

vim.keymap.set('n', '<leader>nn', [[<cmd>Lexplore<cr>]], silent)
vim.keymap.set('n', '<leader>nf', [[<cmd>Lexplore %:p:h<cr>]], silent)

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

require('plugins.lazy')

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

local map = require('config.utils').map

map('n', '<leader><leader>', '/', { silent = true })
map('n', '<leader>bn', ':bn<cr>', { silent = true })
map('n', '<leader>bp', ':bp<cr>', { silent = true })
map('n', '<leader>xr', ':so ~/.config/nvim/init.vim<cr>', { silent = true })

require('plugins')

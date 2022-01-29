vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false
vim.o.autoread = true
vim.o.ignorecase = true
vim.o.lazyredraw = true
vim.o.showmatch = true
vim.o.mat = 0
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.g.noerrorbells = true
vim.g.novisualbell = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.g.nobackup = true
vim.g.nowb = true
vim.g.noswapfile = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = require('config.utils').map

map('n', '<leader><leader>', '/', { silent = true })

require('plugins')


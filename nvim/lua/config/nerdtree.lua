local map = require('config.utils').map

local silent = { silent = true }

map('n', '<leader>nn', [[<cmd>NERDTreeToggle<cr>]], silent)
map('n', '<leader>nf', [[<cmd>NERDTreeFind<cr>]], silent)

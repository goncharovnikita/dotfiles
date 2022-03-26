local map = require('config.utils').map

local silent = { silent = true }

map('n', '<leader>gss', [[<cmd>Git<cr>]], silent)
map('n', '<leader>gll', [[<cmd>GcLog<cr>]], silent)


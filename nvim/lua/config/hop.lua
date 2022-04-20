local map = require('config.utils').map
local silent = { silent = true }

require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
map('n', '<c-h>', [[<cmd>HopWord<cr>]], silent)

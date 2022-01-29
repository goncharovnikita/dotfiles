local map = require('config.utils').map

require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
map('n', '<c-h>', [[<cmd>HopWord<cr>]], silent)

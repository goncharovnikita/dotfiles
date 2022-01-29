local map = require('config.utils').map

local silent = { silent = true }
-- Navigate buffers and repos
map('n', '<leader>fp', [[<cmd>Telescope find_files<cr>]], silent)
map('n', '<leader>fb', [[<cmd>Telescope buffers<cr>]], silent)
map('n', '<leader>fr', [[<cmd>Telescope lsp_references<cr>]], silent)
map('n', '<leader>fi', [[<cmd>Telescope lsp_implementations<cr>]], silent)
map('n', '<leader>fg', [[<cmd>Telescope git_branches<cr>]], silent)
map('n', '<leader>fo', [[<cmd>Telescope treesitter<cr>]], silent)
map('n', '<leader>ff', [[<cmd>Telescope live_grep<cr>]], silent)
map('n', '<leader>fj', [[<cmd>Telescope jumplist<cr>]], silent)
map('n', '<leader>fq', [[<cmd>Telescope projects<cr>]], silent)
map('n', '<leader>fs', [[<cmd>Telescope frecency<cr>]], silent)


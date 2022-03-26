local map = require('config.utils').map

local silent = { silent = true }
-- Navigate buffers and repos
map('n', '<C-p>', [[<cmd>Telescope find_files<cr>]], silent)
map('n', '<C-f>', [[<cmd>Telescope current_buffer_fuzzy_find<cr>]], silent)

map('n', '<leader>fb', [[<cmd>Telescope buffers<cr>]], silent)
map('n', '<leader>ff', [[<cmd>Telescope live_grep<cr>]], silent)
map('n', '<leader>fj', [[<cmd>Telescope jumplist<cr>]], silent)
map('n', '<leader>fq', [[<cmd>Telescope projects<cr>]], silent)
map('n', '<leader>fs', [[<cmd>Telescope frecency<cr>]], silent)
map('n', '<leader>fc', [[<cmd>Telescope commands<cr>]], silent)
map('n', '<leader>fl', [[<cmd>Telescope loclist<cr>]], silent)
map('n', '<leader>fh', [[<cmd>Telescope help_tags<cr>]], silent)
map('n', '<leader>fd', [[<cmd>Telescope diagnostics<cr>]], silent)
map('n', '<leader>fr', [[<cmd>Telescope resume<cr>]], silent)

-- Git
map('n', '<leader>fg', [[<cmd>Telescope git_branches<cr>]], silent)

-- LSP
map('n', '<leader>lfr', [[<cmd>Telescope lsp_references<cr>]], silent)
map('n', '<leader>lfi', [[<cmd>Telescope lsp_implementations<cr>]], silent)
map('n', '<leader>lfo', [[<cmd>Telescope lsp_document_symbols<cr>]], silent)


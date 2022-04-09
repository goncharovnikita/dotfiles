local map = require('config.utils').map
local silent = { silent = true }


require('go').setup({
    run_in_floaterm = false,
})

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

map('n', '<leader>gfs', [[<cmd>GoFillStruct<cr>]], silent)
map('n', '<leader>gtf', [[<cmd>GoTestFunc<cr>]], silent)

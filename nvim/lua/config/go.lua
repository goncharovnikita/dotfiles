require('go').setup({
    test_runner = 'richgo',
    run_in_floaterm = false,
})

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

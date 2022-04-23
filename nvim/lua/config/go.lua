local cfg = _G.localconfig and _G.localconfig.go_config or {}
local map = require('config.utils').map
local silent = { silent = true }

local setup_config = {
	run_in_floaterm = false,
}

if cfg.settings then
	for k, v in pairs(cfg.settings) do
		setup_config[k] = v
	end
end

require('go').setup(setup_config)

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

map('n', '<leader>gfs', [[<cmd>GoFillStruct<cr>]], silent)
map('n', '<leader>gtf', [[<cmd>GoTestFunc<cr>]], silent)


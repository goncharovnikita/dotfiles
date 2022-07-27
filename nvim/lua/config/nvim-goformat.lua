local function format()
	local goformat = require('nvim-goformat')
	goformat.format()
end

-- vim.api.nvim_create_augroup("goformat", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	group = "goformat",
-- 	callback = format,
-- 	pattern = { "*.go" }
-- })

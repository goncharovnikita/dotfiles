vim.api.nvim_create_augroup("detect-k8s-config", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { vim.fn.expand("~/.kube/config") },
	group = "detect-k8s-config",
	callback = function()
		vim.cmd('setfiletype yaml')
	end,
})

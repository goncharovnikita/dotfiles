local cfg = _G.localconfig and _G.localconfig.lsp_config or {}
local nvim_lsp = require("lspconfig")
local runtime_path = vim.split(package.path, ";")

vim.opt.signcolumn = "yes"

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }
  local function buf_set_keymap(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, opts) end

  buf_set_keymap('n', 'gD', vim.lsp.buf.declaration)
  buf_set_keymap('n', 'gd', vim.lsp.buf.definition)
  buf_set_keymap('n', 'K', vim.lsp.buf.hover)
  buf_set_keymap('n', 'gi', vim.lsp.buf.implementation)
  buf_set_keymap('n', '<C-k>', vim.lsp.buf.signature_help)
  buf_set_keymap('n', 'gr', vim.lsp.buf.references)
  buf_set_keymap('n', '[d', vim.diagnostic.goto_prev)
  buf_set_keymap('n', ']d', vim.diagnostic.goto_next)
  buf_set_keymap('n', '<leader>rr', vim.lsp.buf.rename)
  buf_set_keymap('n', '<leader>ca', vim.lsp.buf.code_action)
  buf_set_keymap('n', '<leader>lrr', function()
	vim.cmd "LspRestart"
  end)
  buf_set_keymap('n', '<leader>bff', function()
	  vim.lsp.buf.format { async = false }
  end)
end

local lsp_flags = {
  debounce_text_changes = 500,
}

nvim_lsp.pylsp.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

nvim_lsp.gopls.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
	settings = {
		gopls = cfg.gopls_settings,
	},
})

nvim_lsp.yamlls.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

nvim_lsp.jsonls.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

nvim_lsp.sqls.setup({
	on_attach = function(client, bufnr)
		require("sqls").on_attach(client, bufnr)
		lsp_on_attach(client, bufnr)

		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local opts = { noremap = true, silent = true }

		buf_set_keymap("v", "e", ":SqlsExecuteQuery<CR>", opts)
	end,
	capabilities = capabilities,
	flags = lsp_flags,
})

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.lua_ls.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

nvim_lsp.hls.setup({})

nvim_lsp.clangd.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

local cfg = _G.localconfig and _G.localconfig.lsp_config or {}
local nvim_lsp = require("lspconfig")
local runtime_path = vim.split(package.path, ";")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local function buf_set_keymap(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, opts) end

	buf_set_keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>')
	buf_set_keymap('n', 'gD', vim.lsp.buf.declaration)
	buf_set_keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')
	buf_set_keymap('n', 'gp', vim.lsp.buf.definition)
	buf_set_keymap('n', '<leader>gt', '<cmd>Lspsaga peek_type_definition<CR>')
	buf_set_keymap('n', '<leader>sw', '<cmd>Lspsaga show_workspace_diagnostics<CR>')
	buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
	buf_set_keymap('n', '<C-k>', '<cmd>Lspsaga hover_doc<CR>')
	buf_set_keymap('n', 'gi', vim.lsp.buf.implementation)
	buf_set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
	buf_set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>')
	buf_set_keymap('n', '<leader>o', '<cmd>Lspsaga outline<CR>')
	buf_set_keymap('n', '<leader>rr', vim.lsp.buf.rename)
	buf_set_keymap('n', '<leader>br', '<cmd>Lspsaga rename<CR>')
	buf_set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>')
	buf_set_keymap('n', '<leader>ci', '<cmd>Lspsaga incoming_calls<CR>')
	buf_set_keymap('n', '<leader>co', '<cmd>Lspsaga outgoing_calls<CR>')
	buf_set_keymap('n', '<leader>ad', '<cmd>Lspsaga term_toggle<CR>')
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

nvim_lsp.sqlls.setup({
	on_attach = lsp_on_attach,
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

nvim_lsp.bashls.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

nvim_lsp.elixirls.setup({
	cmd = { vim.fn.expand("~/self/elixir-ls/release/language_server.sh") },
	on_attach = lsp_on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

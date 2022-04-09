local nvim_lsp = require("lspconfig")
local utils = require("config.utils")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local runtime_path = vim.split(package.path, ";")

vim.opt.signcolumn = "yes"

local servers = { "pylsp" }
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>bff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local lsp_flags = {
  debounce_text_changes = 500,
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = lsp_on_attach,
		flags = lsp_flags,
        capabilities = capabilities,
	})
end

nvim_lsp.gopls.setup({
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        gopls = {
        },
    },
})

local function setup_golangci_lint_lsp()
    nvim_lsp.golangci_lint_ls.setup({
        flags = lsp_flags,
        capabilities = capabilities,
        settings = {
            command = { "golangci-lint", "run", "--out-format", "json" }
        },
    })
end


nvim_lsp.sqls.setup({
	on_attach = function(client, bufnr)
		require("sqls").on_attach(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local opts = { noremap = true, silent = true }

		buf_set_keymap("v", "e", ":SqlsExecuteQuery<CR>", opts)
	end,
})

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	on_attach = lsp_on_attach,
	flags = lsp_flags,
    capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})



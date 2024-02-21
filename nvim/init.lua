vim.o.relativenumber = true
vim.o.number = true
vim.o.hlsearch = false
vim.o.autoread = true
vim.o.ignorecase = true
vim.o.lazyredraw = false
vim.o.showmatch = true
vim.o.mat = 0
vim.o.expandtab = false
vim.o.smarttab = true
vim.o.smartindent = true
vim.g.noerrorbells = true
vim.g.novisualbell = true
vim.o.cmdheight = 1
vim.o.cursorline = true
vim.g.signcolumn = "yes"
vim.opt.signcolumn = "yes"

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.breakindent = true

vim.g.nobackup = true
vim.g.nowb = true
vim.g.noswapfile = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

vim.o.termguicolors = true
vim.o.completeopt = "menuone,noselect"

vim.keymap.set("n", "<leader><leader>", "/", { silent = true })
vim.keymap.set("n", "<leader>sr", ":so ~/.config/nvim/init.lua<cr>", { silent = true })
vim.keymap.set("n", "<leader>ss", ":so %<cr>", { silent = true })
vim.keymap.set("n", "<leader>fa", ":e #<cr>", { silent = true })

vim.g.netrw_winsize = 20
vim.g.netrw_keepdir = 1
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3

local silent = { silent = true }

vim.keymap.set("n", "<leader>nn", [[<cmd>Lexplore<cr>]], silent)
vim.keymap.set("n", "<leader>nf", [[<cmd>Lexplore %:p:h<cr>]], silent)

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
vim.cmd([[match ExtraWhitespace /\s\+$/]])

-- Lazy config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local rtp_paths = {}

if _G.localconfig and _G.localconfig.rtp_paths then rtp_paths = _G.localconfig.rtp_paths end

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local treesitter_langs = {
	"go",
	"bash",
	"comment",
	"dockerfile",
	"fish",
	"html",
	"http",
	"json",
	"lua",
	"make",
	"toml",
	"vim",
	"yaml",
	"java",
	"org",
	"regex",
	"markdown",
	"markdown_inline",
	"cpp",
	"c",
	"kdl",
	"elixir",
	"typescript",
}

local lsp_langs = {
	"go",
	"sh",
	"bash",
	"json",
	"lua",
	"yaml",
	"python",
	"java",
	"cpp",
	"c",
	"elixir",
}

local snippets_langs = {
	"go",
	"lua",
}

local plugins = {
	"tpope/vim-commentary",
	"tpope/vim-surround",
	{
		"folke/tokyonight.nvim",
		config = function() vim.cmd.colorscheme("tokyonight-moon") end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		as = "treesitter",
		version = "v0.9.1",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		ft = treesitter_langs,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = treesitter_langs,
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ii"] = "@assignment.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sn"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>sp"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_next = {
							["]c"] = "@conditional.outer",
						},
						goto_previous = {
							["[c"] = "@conditional.outer",
						},
					},
				},
			})

			vim.cmd([[
				set foldmethod=expr
				set foldexpr=nvim_treesitter#foldexpr()
				set nofoldenable
			]])
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				pickers = {
					find_files = {
						find_command = { "fd", "--type", "f", "-H" },
					},
				},
			})

			telescope.load_extension("fzf")
		end,
		lazy = true,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		config = function()
			local ls = require("luasnip")

			vim.keymap.set("i", "<c-k>", function()
				if ls.expand_or_jumpable() then ls.expand_or_jump() end
			end, { silent = true })
		end,
		ft = snippets_langs,
	},

	-- CMP
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				mapping = {
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-n>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<C-p>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
					["<C-k>"] = function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end,
				},
				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
				}, {
					{ name = "buffer" },
				}),
				performance = {
					debounce = 200,
					throttle = 200,
				},
			})

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline("/", {
				sources = {
					{ name = "buffer", max_item_count = 3 },
				},
			})

			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path", max_item_count = 3 },
				}, {
					{
						name = "cmdline",
						max_item_count = 3,
					},
				}),
				completion = {
					keyword_length = 3,
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			local cfg = _G.localconfig and _G.localconfig.lsp_config or {}
			local nvim_lsp = require("lspconfig")
			local runtime_path = vim.split(package.path, ";")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lsp_on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				local function buf_set_keymap(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, opts) end

				buf_set_keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
				buf_set_keymap("n", "gD", vim.lsp.buf.declaration)
				buf_set_keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
				buf_set_keymap("n", "gp", vim.lsp.buf.definition)
				buf_set_keymap("n", "<leader>gt", "<cmd>Lspsaga peek_type_definition<CR>")
				buf_set_keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
				buf_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
				buf_set_keymap("n", "<C-k>", "<cmd>Lspsaga hover_doc<CR>")
				buf_set_keymap("n", "gi", vim.lsp.buf.implementation)
				buf_set_keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
				buf_set_keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
				buf_set_keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
				buf_set_keymap("n", "<leader>rr", vim.lsp.buf.rename)
				buf_set_keymap("n", "<leader>br", "<cmd>Lspsaga rename<CR>")
				buf_set_keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
				buf_set_keymap("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
				buf_set_keymap("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
				buf_set_keymap("n", "<leader>ad", "<cmd>Lspsaga term_toggle<CR>")
				buf_set_keymap("n", "<leader>lrr", function() vim.cmd("LspRestart") end)
				buf_set_keymap("n", "<leader>bff", function() vim.lsp.buf.format({ async = false }) end)
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
		end,
		ft = lsp_langs,
	},
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = { enable = false },
				outline = {
					win_width = 50,
				},
			})
		end,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},
	{
		"j-hui/fidget.nvim",
		branch = "legacy",
		config = function() require("fidget").setup({}) end,
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local oil = require("oil")

			oil.setup({
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					-- ["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				use_default_keymaps = false,
				float = {
					padding = 16,
					max_width = 640,
					max_height = 480,
					border = "rounded",
					win_options = {
						winblend = 20,
					},
				},
			})

			vim.keymap.set("n", "<leader>nn", function() oil.toggle_float() end, silent)
			vim.keymap.set("n", "<leader>nf", function() oil.toggle_float() end, silent)
		end,
	},

	{ "lukas-reineke/indent-blankline.nvim" },
	{ "aklt/plantuml-syntax" },

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{
		"rcarriga/nvim-dap-ui",
		config = function() require("dapui").setup() end,
	},
	{
		"Weissle/persistent-breakpoints.nvim",
		config = function()
			require("persistent-breakpoints").setup({
				load_breakpoints_event = { "BufReadPost" },
			})
		end,
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup({
				dap_configurations = {
					{
						-- Must be "go" or it will be ignored by the plugin
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
			})
		end,
	},
	{
		"jbyuki/one-small-step-for-vimkind",
		config = function()
			local dap = require("dap")
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.adapters.nlua = function(callback) callback({ type = "server", host = "127.0.0.1", port = 8086 }) end
		end,
	},
	{ "folke/neodev.nvim", opts = {} },
	{ "MunifTanjim/nui.nvim" },
	{
		"sotte/presenting.nvim",
		opts = {
			separator = {
				-- markdown = ">>pnextslide",
			},
			options = {
				width = 70,
			},
		},
		cmd = { "Presenting" },
	},
}

require("lazy").setup(plugins, {
	performance = {
		rtp = {
			paths = rtp_paths,
		},
		disabled_plugins = {
			"netrwPlugin",
			"tutor",
		},
	},
})

local function telescope(method)
	return function() require("telescope.builtin")[method]() end
end

-- Telescope
vim.keymap.set("n", "<C-p>", telescope("find_files"), silent)
vim.keymap.set("n", "<C-f>", telescope("current_buffer_fuzzy_find"), silent)

vim.keymap.set("n", "<leader>fb", telescope("buffers"), silent)
vim.keymap.set("n", "<leader>ff", telescope("live_grep"), silent)
vim.keymap.set("n", "<leader>fj", telescope("jumplist"), silent)
vim.keymap.set("n", "<leader>fc", telescope("commands"), silent)
vim.keymap.set("n", "<leader>fl", telescope("loclist"), silent)
vim.keymap.set("n", "<leader>fh", telescope("help_tags"), silent)
vim.keymap.set("n", "<leader>fd", telescope("diagnostics"), silent)
vim.keymap.set("n", "<leader>fr", telescope("resume"), silent)

-- LSP
vim.keymap.set("n", "<leader>lfr", telescope("lsp_references"), silent)
vim.keymap.set("n", "<leader>lfi", telescope("lsp_implementations"), silent)
vim.keymap.set("n", "<leader>lfo", telescope("lsp_document_symbols"), silent)

-- DAP
vim.keymap.set("n", "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, silent)
vim.keymap.set("n", "<leader>dsi", function() require("dap").step_into() end, silent)
vim.keymap.set("n", "<leader>dso", function() require("dap").step_out() end, silent)
vim.keymap.set("n", "<leader>dsn", function() require("dap").step_over() end, silent)
vim.keymap.set("n", "<leader>dsc", function() require("dap").continue() end, silent)
vim.keymap.set("n", "<leader>dsq", function() require("dap").terminate() end, silent)
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, silent)
vim.keymap.set({ "n", "v" }, "<leader>duh", function() require("dap.ui.widgets").hover() end, silent)
vim.keymap.set({ "n", "v" }, "<leader>dup", function() require("dap.ui.widgets").preview() end, silent)
vim.keymap.set("n", "<leader>duf", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, silent)
vim.keymap.set("n", "<leader>dus", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, silent)
vim.keymap.set("n", "<leader>dtf", function() require("dap-go").debug_test() end, silent)
vim.keymap.set("n", "<leader>dtr", function() require("dap-go").debug_last_test() end, silent)
vim.keymap.set("n", "<leader>duo", function() require("dapui").open() end, silent)
vim.keymap.set("n", "<leader>duc", function() require("dapui").close() end, silent)

--- Presentation
vim.keymap.set("n", "<leader>ppp", function() require("presenting").start() end, silent)

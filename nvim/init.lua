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

if _G.localconfig and _G.localconfig.rtp_paths then
	rtp_paths = _G.localconfig.rtp_paths
end

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
		config = function()
			vim.cmd.colorscheme("tokyonight-moon")
		end,
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
				},
			})
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
			require("config.telescope")
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
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
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
			require("config.cmp")
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp")
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
		config = function()
			require("fidget").setup({})
		end,
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.g.neo_tree_remove_legacy_commands = 1

			require("neo-tree").setup({})
		end,
	},

	{ "lukas-reineke/indent-blankline.nvim" },
	{ "aklt/plantuml-syntax" },

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()
		end,
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

			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
		end,
	},
	{ "folke/neodev.nvim", opts = {} },
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
	return function()
		require("telescope.builtin")[method]()
	end
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

-- Neotree
vim.keymap.set("n", "<leader>nn", "<cmd>Neotree toggle<CR>", silent)
vim.keymap.set("n", "<leader>nf", "<cmd>Neotree reveal<CR>", silent)

-- DAP
vim.keymap.set("n", "<leader>db", function()
	require("persistent-breakpoints.api").toggle_breakpoint()
end, silent)
vim.keymap.set("n", "<leader>dsi", function()
	require("dap").step_into()
end, silent)
vim.keymap.set("n", "<leader>dso", function()
	require("dap").step_out()
end, silent)
vim.keymap.set("n", "<leader>dsn", function()
	require("dap").step_over()
end, silent)
vim.keymap.set("n", "<leader>dsc", function()
	require("dap").continue()
end, silent)
vim.keymap.set("n", "<leader>dsq", function()
	require("dap").terminate()
end, silent)
vim.keymap.set("n", "<leader>dr", function()
	require("dap").repl.open()
end, silent)
vim.keymap.set({ "n", "v" }, "<leader>duh", function()
	require("dap.ui.widgets").hover()
end, silent)
vim.keymap.set({ "n", "v" }, "<leader>dup", function()
	require("dap.ui.widgets").preview()
end, silent)
vim.keymap.set("n", "<leader>duf", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, silent)
vim.keymap.set("n", "<leader>dus", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, silent)
vim.keymap.set("n", "<leader>dtf", function()
	require("dap-go").debug_test()
end, silent)
vim.keymap.set("n", "<leader>dtr", function()
	require("dap-go").debug_last_test()
end, silent)
vim.keymap.set("n", "<leader>duo", function()
	require("dapui").open()
end, silent)
vim.keymap.set("n", "<leader>duc", function()
	require("dapui").close()
end, silent)

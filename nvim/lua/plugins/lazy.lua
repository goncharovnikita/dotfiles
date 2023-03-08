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
}

local lsp_langs = {
	"go",
	"bash",
	"json",
	"lua",
	"yaml",
	"python",
	"java",
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
			vim.cmd.colorscheme('tokyonight-moon')
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		as = "treesitter",
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		ft = treesitter_langs,
		config = function()
			require('nvim-treesitter.configs').setup({
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
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
				}
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = '0.1.1',
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require('config.telescope')
		end,
		lazy = true,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local ls = require("luasnip")

			vim.keymap.set('i', '<c-k>', function()
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
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require('config.cmp')
		end,
		lazy = true
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			require('config.lsp')
		end,
		ft = lsp_langs,
	}
}

require("lazy").setup(plugins,
	{
		performance = {
			rtp = {
				paths = rtp_paths,
			},
		},
	}
)


local function telescope(method)
	return function()
		require('telescope.builtin')[method]()
	end
end

local silent = { silent = true }

vim.keymap.set('n', '<C-p>', telescope('find_files'), silent)
vim.keymap.set('n', '<C-f>', telescope('current_buffer_fuzzy_find'), silent)

vim.keymap.set('n', '<leader>fb', telescope('buffers'), silent)
vim.keymap.set('n', '<leader>ff', telescope('live_grep'), silent)
vim.keymap.set('n', '<leader>fj', telescope('jumplist'), silent)
vim.keymap.set('n', '<leader>fc', telescope('commands'), silent)
vim.keymap.set('n', '<leader>fl', telescope('loclist'), silent)
vim.keymap.set('n', '<leader>fh', telescope('help_tags'), silent)
vim.keymap.set('n', '<leader>fd', telescope('diagnostics'), silent)
vim.keymap.set('n', '<leader>fr', telescope('resume'), silent)

-- LSP
vim.keymap.set('n', '<leader>lfr', telescope('lsp_references'), silent)
vim.keymap.set('n', '<leader>lfi', telescope('lsp_implementations'), silent)
vim.keymap.set('n', '<leader>lfo', telescope('lsp_document_symbols'), silent)

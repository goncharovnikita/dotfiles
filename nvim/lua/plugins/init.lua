-- Plugin definition and loading
-- local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd

-- Boostrap Packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

cmd([[packadd packer.nvim]])

local packer = require('packer')

local use = packer.use
local silent = { silent = true }

packer.startup(function()
	use("wbthomason/packer.nvim")

	use("tpope/vim-commentary")

	use("tpope/vim-sensible")

	use("tpope/vim-surround")

	-- Colorschemes
	use({ "monsonjeremy/onedark.nvim", config = function ()
		vim.o.background = 'dark'
		require('onedark').setup()
	end })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = [[require('config.treesitter')]] })
	use({ 'nvim-treesitter/nvim-treesitter-context', config = function ()
		require'treesitter-context'.setup()
	end })
	use 'nvim-treesitter/nvim-treesitter-textobjects'

	-- Telescope
	use({
		{
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"telescope-fzf-native.nvim",
			},
			wants = {
				"popup.nvim",
				"plenary.nvim",
				"telescope-fzf-native.nvim",
			},
			config = [[require('config.telescope')]],
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		},
	})

	-- Icons
	use("kyazdani42/nvim-web-devicons")

	-- Sql
	use({ "nanotee/sqls.nvim" })

	-- Git
	use({ "tpope/vim-fugitive", config = function ()
		vim.keymap.set('n', '<leader>gss', [[<cmd>Git<cr>]], silent)
		vim.keymap.set('n', '<leader>gll', [[<cmd>GcLog<cr>]], silent)
	end })

	-- CMP
	use({ "L3MON4D3/LuaSnip" }) -- Snippets plugin
	use({ "hrsh7th/nvim-cmp" }) -- Autocompletion plugin
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
	use({ "saadparwaiz1/cmp_luasnip", config = [[require('config.cmp')]] })

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		config = [[require('config.lsp')]],
	})

	if _G.localconfig and _G.localconfig.plugins then
		for _, p in pairs(_G.localconfig.plugins) do
			p(use)
		end
	end
end)

-- Go
require('config.go')

-- Netrw

vim.g.netrw_winsize = 20
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3

vim.keymap.set('n', '<leader>nn', [[<cmd>Lexplore<cr>]], silent)
vim.keymap.set('n', '<leader>nf', [[<cmd>Lexplore %:p:h<cr>]], silent)


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

packer.startup(function()
	use("wbthomason/packer.nvim")

	use("tpope/vim-commentary")

	use("tpope/vim-surround")

	-- Colorschemes
	use({ "catppuccin/nvim", as = "catppuccin", config = function ()
       vim.cmd.colorscheme('catppuccin-mocha')
	end })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		as = "treesitter",
		config = [[require('config.treesitter')]],
	})
	use({ 'nvim-treesitter/nvim-treesitter-context', config = function ()
		require'treesitter-context'.setup()
	end, after = "treesitter"})
	use({ 'nvim-treesitter/nvim-treesitter-textobjects', after = "treesitter"})

	-- Telescope
	use({
		{
			"nvim-telescope/telescope.nvim",
			tag = '0.1.1',
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

	-- Sql
	use({ "nanotee/sqls.nvim" })

	-- CMP
	use({ "L3MON4D3/LuaSnip", config = [[require('config.luasnip')]] })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
		},
		config = [[require('config.cmp')]],
	})

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


-- Plugin definition and loading
-- local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd

-- Boostrap Packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Rerun PackerCompile everytime pluggins.lua is updated
cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

cmd([[packadd packer.nvim]])

local packer = require('packer')
local use = packer.use

packer.startup(function()
	use("wbthomason/packer.nvim")

	use("tpope/vim-commentary")

	use("tpope/vim-sensible")

	use("tpope/vim-surround")

	use("nathanaelkane/vim-indent-guides")

	-- Colorschemes
	use({ "monsonjeremy/onedark.nvim", config = [[require('config.colorscheme')]] })

	-- Navigation
	use({ "phaazon/hop.nvim", config = [[require('config.hop')]] })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = [[require('config.treesitter')]] })
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
			setup = [[require('config.telescope_setup')]],
			config = [[require('config.telescope')]],
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		},
	})

	-- Icons
	use("kyazdani42/nvim-web-devicons")

	-- Tree
	use({ "preservim/nerdtree", config = [[require('config.nerdtree')]] })

	-- Go
	use({ "ray-x/go.nvim", ft = { "go" }, config = [[require('config.go')]] })

	-- Sql
	use({ "nanotee/sqls.nvim" })

	-- Git
	use({ "tpope/vim-fugitive", config = [[require('config.git')]] })

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

end)


-- Plugin definition and loading
-- local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd

-- Boostrap Packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone','https://github.com/wbthomason/packer.nvim', install_path})
end

-- Rerun PackerCompile everytime pluggins.lua is updated
cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-commentary'

    use 'tpope/vim-sensible'

    use 'tpope/vim-surround'

    use 'nathanaelkane/vim-indent-guides'

    -- Colorschemes
    use { 'monsonjeremy/onedark.nvim', config = [[require('config.colorscheme')]] }

    -- Navigation
    use { 'phaazon/hop.nvim', config = [[require('config.hop')]] }

    -- Statusline
    use { 'nvim-lualine/lualine.nvim', config = [[require('config.lualine')]] }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Telescope
    use {
          {
          'nvim-telescope/telescope.nvim',
          requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'telescope-frecency.nvim',
            'telescope-fzf-native.nvim',
          },
          wants = {
            'popup.nvim',
            'plenary.nvim',
            'telescope-frecency.nvim',
            'telescope-fzf-native.nvim',
          },
          setup = [[require('config.telescope_setup')]],
          config = [[require('config.telescope')]],
          cmd = 'Telescope',
          module = 'telescope',
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
    }

    -- Icons
    use 'kyazdani42/nvim-web-devicons'

    -- Mini
    use { 'echasnovski/mini.nvim', branch = 'stable', config = [[require('config.mini')]] }

    -- Tree
    use { 'kyazdani42/nvim-tree.lua', disable = true, config = [[require('config.nvim-tree')]] }
    use { 'ms-jpq/chadtree', disable = true, branch = 'chad', run = 'python3 -m chadtree deps' }
    use { 'preservim/nerdtree', config = [[require('config.nerdtree')]] }

    -- Sniprun
    use { 'michaelb/sniprun', run = 'bash install.sh' }

    -- Go
    use { 'ray-x/go.nvim', opt = true, ft = { 'go' }, config = [[require('config.go')]] }

    -- LSP
    use { 'neovim/nvim-lspconfig', opt = true, ft = { 'go' }, config = [[require('config.lsp')]] }

    -- Sql
    use { 'nanotee/sqls.nvim', opt = true, ft = { 'sql' } }

    -- Project
    use { 'ahmedkhalf/project.nvim', config = [[require('config.project')]] }

    -- Linter
    use { 'mfussenegger/nvim-lint', opt = true, ft = { 'go' } }
end)

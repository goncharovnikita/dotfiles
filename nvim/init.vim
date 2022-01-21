call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-sensible'

Plug 'tpope/vim-surround'

Plug 'nathanaelkane/vim-indent-guides'

" Colorschemes
Plug 'monsonjeremy/onedark.nvim'

" Navigation
Plug 'phaazon/hop.nvim'

" Statusline
Plug 'nvim-lualine/lualine.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Tabs
" Plug 'romgrk/barbar.nvim'

" Mini
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }

" Tree
Plug 'kyazdani42/nvim-tree.lua'

" Sniprun
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}

" Go
Plug 'ray-x/go.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'

" Neovim
" Plug 'TimUntersberger/neogit'

" Sql
Plug 'nanotee/sqls.nvim'

" Project
Plug 'ahmedkhalf/project.nvim'

" Linter
Plug 'mfussenegger/nvim-lint'

" Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Vsnip
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

let mapleader = " "
set nocompatible
set number
set relativenumber
syntax enable
filetype plugin indent on
" set guicursor+=a:blinkon0
set scrolloff=1

" GUI options
set guioptions-=r
set guioptions-=L

" Statusline
set statusline=\ %f " curr filename
set statusline+=\ %m " is modified
set statusline+=%=  " start from right

" Theme
lua <<EOF
require('onedark').setup()
EOF
let g:deus_termcolors=256

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Off syntax on large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | set ft=none | endif

" Set to auto read when a file is changed from the outside
set autoread

" Ignore case when searching
set ignorecase

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=0

" Use spaces instead of tabs
set expandtab

set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set smartindent

" No annoying sound on errors
set noerrorbells
set novisualbell
set visualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
en
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

nnoremap <leader><Space> /

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>bn :BufferNext<CR>
nnoremap <leader>bp :BufferPrevious<CR>
nnoremap <leader>bc :BufferClose<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

""""PLUGINS""""
""""""""""""""""

" Indent guides
let g:indent_guides_enable_on_vim_startup = 0

" Fugitive
nnoremap <leader>gpl :Neogit pull<CR>
nnoremap <leader>gps :Neogit push<CR>
nnoremap <leader>gss :Neogit<CR>

" Hop
lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
nnoremap <c-h> :HopWord<CR>

" Treesitter
lua <<EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = "maintained",

  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})
EOF

" Telescope
nnoremap <leader>fp <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fa <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>fg <cmd>Telescope git_branches<cr>
nnoremap <leader>fo <cmd>Telescope treesitter<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>fj <cmd>Telescope jumplist<cr>
nnoremap <leader>fq <cmd>Telescope projects<cr>

lua <<EOF
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
EOF


" Lualine
lua <<EOF
require('lualine').setup({
    theme = 'onedark'
})
EOF

" Mini
lua require('mini.starter').setup()
lua require('mini.trailspace').setup()

" Tree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

lua require('nvim-tree').setup()

" Go
lua <<EOF
require('go').setup()
-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
EOF

" LSP
lua << EOF
local nvim_lsp = require('lspconfig')
vim.opt.signcolumn = "yes"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 500,
    }
  }
end
EOF

" Barbar
lua <<EOF
vim.g.bufferline = {
  -- Enable/disable animations
  animation = false,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = true,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = false,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = false,

  icons = true,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}
EOF

" SQL
lua <<EOF
require('lspconfig').sqls.setup{
    on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }

        buf_set_keymap('v', 'e', ':SqlsExecuteQuery<CR>', opts)
    end
}
EOF

" Project
lua <<EOF
require('project_nvim').setup({
    manual_mode = true
})

require('telescope').load_extension('projects')
EOF

" Linter
lua <<EOF
require('lint').linters_by_ft = {
  go = {'golangcilint'}
}

-- vim.api.nvim_exec([[ autocmd BufWritePost *.go :silent! lua require('lint').try_lint() ]], false)

EOF

" Completion

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    enabled = false,
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF


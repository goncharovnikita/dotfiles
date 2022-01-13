call plug#begin('~/.config/nvim/plugged')

Plug 'mileszs/ack.vim'

Plug 'preservim/nerdtree'

Plug 'jlanzarotta/bufexplorer'

Plug 'vim-scripts/mru.vim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-sensible'

Plug 'tpope/vim-surround'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'junegunn/gv.vim'

" JS/JSX
Plug 'yuezk/vim-js'

Plug 'maxmellon/vim-jsx-pretty'

" Colorschemes
Plug 'dracula/vim'

" Navigation
Plug 'phaazon/hop.nvim'

" Modeline
Plug 'nvim-lualine/lualine.nvim'
"" Modeline icons
Plug 'kyazdani42/nvim-web-devicons'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

let mapleader = ","
set nocompatible
set number
set relativenumber
syntax enable
set guifont=JetBrainsMono\ Nerd\ Font:h14
filetype plugin indent on
set guicursor+=a:blinkon0
set scrolloff=1
set clipboard=unnamedplus   " using system clipboard

" GUI options
set guioptions-=r
set guioptions-=L

" Statusline
set statusline=\ %f " curr filename
set statusline+=\ %m " is modified
set statusline+=%=  " start from right

" Theme
colorscheme dracula
set background=dark
let g:deus_termcolors=256
" hi Normal ctermbg=NONE guibg=NONE

" Set extra options when running in GUI mode
if has("gui_running")
    "set guioptions-=T
    "set guioptions-=e
    set t_Co=256
    "set guitablabel=%M\ %t
endif

" Buffer movement
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k

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
set mat=2

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
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

nnoremap <Space> /

nnoremap <leader>tn :tabnew<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

""""PLUGINS""""
""""""""""""""""

" NerdTree
nnoremap <leader>nn :NERDTreeToggle<cr>
nnoremap <leader>nb :NERDTreeFromBookmark<Space>
nnoremap <leader>nf :NERDTreeFind<cr>
let g:NERDTreeWinPos = "right"

" Indent guides
let g:indent_guides_enable_on_vim_startup = 0

" MRU
nnoremap <leader>f :MRU<cr>

" CtrlP
let g:ctrlp_max_height = 20

" Go setup
autocmd FileType go map <leader>gi :GoImports<CR>
autocmd FileType go map <c-]> <Plug>(go-def)<cr>

" Bufexplorer
nnoremap <leader>o :BufExplorer<CR>

" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nnoremap <leader>F :Ack<Space>

" CtrlP
let g:ctrlp_map = '<leader>j'
let g:ctrlp_show_hidden = 1

" Goyo
nnoremap <leader>z :Goyo<CR>

nnoremap <leader>s[ :call JumpToPrevSleeperPoint()<CR>

" Fugitive
nnoremap <leader>gpl :Gpull<CR>
nnoremap <leader>gps :Gpush<CR>
nnoremap <leader>gss :Gstatus<CR>

" Hop
lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
nnoremap <c-h> :HopWord<CR>

" WebDevicons
lua require('nvim-web-devicons').setup()

" Lualine
lua require('lualine').setup()

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
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
}
EOF


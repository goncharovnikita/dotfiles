set shell=/bin/bash
execute pathogen#infect()

let mapleader = ","
set number
set relativenumber
syntax enable
set guifont=RobotoMono\ Nerd\ Font:h14
filetype plugin indent on
set guicursor+=a:blinkon0
set scrolloff=1

" GUI options
set guioptions-=r
set guioptions-=L

" Statusline
set statusline=\ %f " curr filename
set statusline+=\ %m " is modified
set statusline+=%=  " start from right

" Theme
colorscheme gruvbox
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

set wildignore+=*/node_modules/*,/\.git/*

nnoremap <Space> /

nnoremap <leader>tn :tabnew<CR>
if has('python3')
endif

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

" " Ale
let g:py_linters = ['pylint']
let g:ale_linters = {
    \ "python": py_linters,
    \ }
let g:js_fixers = ['eslint']
let g:ale_fixers = {
    \ "javascript": js_fixers,
    \ "typescript": js_fixers,
    \ }
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = "never"
let g:ale_set_signs = 0
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

nnoremap <silent> ]g :ALENext<CR>
nnoremap <silent> [g :ALEPrevious<CR>

autocmd FileType javascript,javascriptreact,typescript,javascript.jsx,typescript.tsx map <c-]> :ALEGoToDefinition<cr>

" integrate Ale with statusline
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline+=%{LinterStatus()}\  

" Emmet
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

" Go setup
autocmd FileType go map <leader>gi :GoImports<CR>

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

" Sleeper
let g:sleeper_point = '<++>'
function! JumpToPrevSleeperPoint() 
    let @/ = g:sleeper_point
    normal! N<CR>
endfunction




nnoremap <leader>s[ :call JumpToPrevSleeperPoint()<CR>

" Fugitive
nnoremap <leader>gpl :Gpull<CR>
nnoremap <leader>gps :Gpush<CR>
nnoremap <leader>gss :Gstatus<CR>

" Tsuquyomi
let g:tsuquyomi_disable_default_mappings = 1
let g:tsuquyomi_single_quote_import = 1
let g:tsuquyomi_disable_quickfix = 1

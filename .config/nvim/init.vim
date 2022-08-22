" -------------------------------------
"  General settings
" -------------------------------------

" Whitespace handling

filetype plugin indent on
set autoindent
set tabstop=2
set shiftround
set shiftwidth=2
set softtabstop=2
set expandtab
set wrap

" Editing

set formatoptions=cjqrn1
set showmatch
set textwidth=120

" Visual

set colorcolumn=120
set cursorline
set laststatus=2
set number
set relativenumber
set showcmd
set showmode

" Search

set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault

" Splits

set splitbelow
set splitright

" Other

set confirm
set mouse=a
set encoding=utf-8
set scrolloff=3
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*.pyc
set visualbell
set backspace=indent,eol,start
set completeopt=menuone,longest,preview
set clipboard+=unnamedplus

let g:markdown_fenced_languages = ['swift', 'python', 'ruby', 'javascript', 'typescript']

" -------------------------------------
" Key mappings
" -------------------------------------

nnoremap <leader><space> :nohlsearch<cr>

" Position search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" Fast tab switching
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>0 :tablast<cr>

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>

" Use / as a search short-cut
nnoremap / /\v

" Folding
nnoremap <leader>z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<cr>

" Zoom a Vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Ruby bindings

augroup Ruby
  autocmd!

  " Insert breakpoint
  autocmd filetype ruby nnoremap <buffer> <leader>b Obinding.pry<esc>==
  autocmd filetype ruby nnoremap <buffer> <leader>B Obyebug<esc>==

  " Insert frozen string literal sigel at the top of the file
  autocmd filetype ruby nnoremap <buffer> <leader>F ggO# frozen_string_literal: true<cr><esc>0D
augroup END

if executable('pbcopy')
  " Copy current file name to the clipboard
  nnoremap <leader>f :!echo -n % \| pbcopy<cr><cr>
endif

" -------------------------------------
"  Plugins
" ------------------------------------

let plugin_dir = stdpath('data') . '/site/plugins/'

call plug#begin(plugin_dir)

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'
Plug 'tanvirtin/monokai.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jparise/vim-graphql'
Plug 'elzr/vim-json'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'Shopify/vim-sorbet', { 'branch': 'master' }
Plug 'tpope/vim-surround'
Plug 'vim-test/vim-test'

if has("macunix")
  Plug 'rizzatti/dash.vim'
endif

call plug#end()

if !isdirectory(plugin_dir)
  call mkdir(plugin_dir)
  PlugInstall
endif

" -------------------------------------
"  Plugin configuration
" -------------------------------------

" Ale

let g:ale_linters = {
      \ 'ruby': ['rubocop', 'sorbet'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ }
let g:ale_lingers_ignore = {
      \ 'ruby': ['brakeman'],
      \ }

let g:ale_line_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" monokai.nvim
colorscheme monokai

" telescope

nnoremap <C-a> :Telescope find_files<cr>
nnoremap <C-p> :Telescope git_files<cr>

" vim-airline/vim-airline-themes
let g:airline_powerline_fonts = 1
let g:airline_theme = 'minimalist'

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-test
let test#strategy = 'dispatch'

nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>n :TestNearest<CR>
nmap <silent> <leader>s :TestSuite<CR>

if has("macunix")
  " dash.vim
  nmap <silent> <leader>h <Plug>DashSearch
endif

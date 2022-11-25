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

" Open a terminal (shell)
nmap <silent> <leader>s :split term://zsh<CR>
nmap <silent> <leader>S :vsplit term://zsh<CR>

" Unhighlight search results
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

let g:ale_disable_lsp=1

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

" =====================================
"  Plugin configuration
" =====================================

" -------------------------------------
" Ale
" -------------------------------------
let g:ale_linters = {
      \ 'ruby': ['rubocop'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ }
let g:ale_lingers_ignore = {
      \ 'ruby': ['brakeman'],
      \ }

let g:ale_ruby_rubocop_executable = 'bin/rubocop'
let g:ale_line_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" -------------------------------------
" CoC
" -------------------------------------
let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" <cr> confirms completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Show documentation
nnoremap <silent> K :call CocAction('doHover')<CR>

" Source navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> fh <Plug>(coc-float-hide)

" Perform code action on word at cursor
nmap <leader>do <Plug>(coc-codeaction)

" Rename a symbol
nmap <leader>rn <Plug>(coc-rename)

" When hovering over a word, show diagnostic if it exists, otherwise show documentation
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

" -------------------------------------
" monokai.nvim
" -------------------------------------
set termguicolors
colorscheme monokai

highlight CocFloating guibg=grey

" -------------------------------------
" telescope
" -------------------------------------
nnoremap <C-a> :Telescope find_files<cr>
nnoremap <C-p> :Telescope git_files<cr>

" -------------------------------------
" vim-airline/vim-airline-themes
" -------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'minimalist'

" -------------------------------------
" vim-json
" -------------------------------------
let g:vim_json_syntax_conceal = 0

" -------------------------------------
" vim-test
" -------------------------------------
let test#strategy = 'dispatch'

nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>n :TestNearest<CR>

if has("macunix")
  " dash.vim
  nmap <silent> <leader>h <Plug>DashSearch
endif

autocmd TermOpen * DisableWhitespace
autocmd TermOpen * startinsert

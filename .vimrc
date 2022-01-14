" -------------------------------------
"  General settings
" -------------------------------------

set nocompatible

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
set clipboard=unnamed

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

" Ruby bindings

augroup Ruby
  autocmd!

  " Insert breakpoint
  autocmd filetype ruby nnoremap <buffer> <leader>b Obinding.pry<esc>==
  autocmd filetype ruby nnoremap <buffer> <leader>B Obyebug<esc>==

  " Insert frozen string literal sigel at the top of the file
  autocmd filetype ruby nnoremap <buffer> <leader>F ggO# frozen_string_literal: true<cr><esc>0D
augroup END

if has("macunix")
  " Copy current file name to the clipboard
  nnoremap <leader>f :!echo -n % \| pbcopy<cr><cr>
endif

" -------------------------------------
"  Plugins
" ------------------------------------

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.vim/config/airline.vim
source ~/.vim/config/ale.vim
source ~/.vim/config/coc.vim
source ~/.vim/config/dash-app.vim
source ~/.vim/config/fzf-plugin.vim
source ~/.vim/config/molokai.vim
source ~/.vim/config/nerdtree.vim
source ~/.vim/config/supertab.vim
source ~/.vim/config/swift-plugin.vim
source ~/.vim/config/typescript.vim
source ~/.vim/config/vim-better-whitespace.vim
source ~/.vim/config/vim-bundler.vim
source ~/.vim/config/vim-commentary.vim
source ~/.vim/config/vim-dispatch.vim
source ~/.vim/config/vim-endwise.vim
source ~/.vim/config/vim-fugitive.vim
source ~/.vim/config/vim-gitgutter.vim
source ~/.vim/config/vim-graphql.vim
source ~/.vim/config/vim-json.vim
source ~/.vim/config/vim-rails.vim
source ~/.vim/config/vim-repeat.vim
source ~/.vim/config/vim-surround.vim
source ~/.vim/config/vim-test.vim

call plug#end()
" doautocmd User PlugLoaded

" -------------------------------------
" Auto commands
" -------------------------------------

autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

autocmd FileType sh setl sw=2 sts=2 et

autocmd StdinReadPre * let s:std_in=1

autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell

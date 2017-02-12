filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

set nocompatible

set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

colorscheme molokai

syntax on
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*.pyc
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set relativenumber
set clipboard=unnamed
set mouse=a
set completeopt=menuone,longest,preview

set splitbelow
set splitright

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>

set wrap
set textwidth=120
set formatoptions=qrn1
set colorcolumn=120

let NERDTreeIgnore = ['\.pyc$']
nmap <leader>d :NERDTreeToggle<CR>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor

  let g:ctrlp_use_caching = 0
  let g:ctrlp_user_command = 'ag %s -i -l --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .DS_Store
        \ -g ""'
else
  let g:ctrlp_use_caching = 1
  let g:ctrlp_custom_ignore = {
      \ 'dir': '\v[\/](\.git|\.hg|\.svn|html|node_modules)$',
      \ 'file': '\v.(exe|so|dll|pyc|class|png|jpg|jpeg|gif)$',
      \ }
endif

let g:flake8_max_line_length=120
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

autocmd BufWritePost *.py call Flake8()
autocmd FileType sh setl sw=2 sts=2 et
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufNewFile,BufRead *.json set ft=javascript

" Add the virtualenv's site packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    nmap <silent> <leader>h <Plug>DashSearch
  endif
endif

let g:airline_powerline_fonts=1

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatusLineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']

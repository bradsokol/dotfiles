filetype off
call pathogen#infect()
call pathogen#helptags()

colorscheme slate

filetype on
syntax on
filetype plugin indent on

let NERDTreeIgnore = ['\.pyc$']

" Use the OS clipboard by default
set clipboard=unnamed

" Enhanced command line completion
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*.pyc
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v.(exe|so|dll|pyc|class)$',
    \ }

" Optimize for fast terminal connections
set ttyfast

" Line numbers
set number

" Highlight searches
set hlsearch

" Ignore case in searches
set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" SHow the current mode
set showmode

set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line

" make backspaces more powerful
set backspace=indent,eol,start

set ruler                           " show line and column number
set showcmd 			" show (partial) command in status line

let g:flake8_max_line_length=120
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

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

nmap <leader>d :NERDTreeToggle<CR>

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    nmap <silent> <leader>h <Plug>DashSearch
  endif
endif

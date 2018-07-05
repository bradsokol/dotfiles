" vim: foldmethod=marker foldlevel=0

" Temporary fix for Python 3.7
if has('python3')
  silent! python3 1
endif

" Appearance {{{
colorscheme molokai
" }}}

" Clipboard {{{
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " Map */+ registers to macOS pastebuffer
    set clipboard=unnamed
  endif
endif
" }}}

" Editing {{{
filetype plugin indent on
set autoindent
set formatoptions=cjqrn1
set textwidth=120
" }}}

" Mouse {{{
if has("mouse")
  set mouse=a
endif
" }}}

" Python {{{
au FileType python set omnifunc=pythoncomplete#Complete

" Add the virtualenv's site packages to vim path
py3 << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
" }}}

" Search {{{
set incsearch
set showmatch
set hlsearch
set ignorecase
set smartcase
set gdefault
nnoremap <leader><space> :noh<cr>
" }}}

" Splits {{{
set splitbelow
set splitright
" }}}

" Syntax highlighting {{{
syntax on
" }}}

" TTY performance {{{
set nocompatible
set ttyfast
" }}}

" Visual {{{
set colorcolumn=120
set cursorline
set laststatus=2
set number
set relativenumber
set showcmd
set showmode
" }}}

" Whitespace handling {{{
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set wrap
" }}}

" Folding {{{
" Fold showing only search results
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
nnoremap <leader>z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<cr>
" }}}
"
" Experiments {{{
" Zoom / Restore window {{
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <leader>Z :ZoomToggle<cr>
" }}}
" }}}
"
" Other {{{
set encoding=utf-8
set scrolloff=3
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*.pyc
set visualbell
set backspace=indent,eol,start
set completeopt=menuone,longest,preview

autocmd FileType sh setl sw=2 sts=2 et
autocmd StdinReadPre * let s:std_in=1
autocmd BufNewFile,BufRead *.json set ft=javascript

au FileType gitcommit setlocal spell
au FileType markdown setlocal spell

nnoremap / /\v
nnoremap <leader>b Obinding.pry<esc>
vnoremap / /\v
if has("macunix")
  nnoremap <leader>f :!echo % \| pbcopy<cr><cr>
endif
" }}}

" Plugin Configurations {{{

" Airline {{{
let g:airline_powerline_fonts=1
let g:airline_theme = 'minimalist'
" }}}

" ALE {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" }}}

" CtrlP {{{
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
" }}}

" Dash Search {{{
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    nmap <silent> <leader>h <Plug>DashSearch
  endif
endif
" }}}

" Flake8 {{{
let g:flake8_max_line_length=120
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1
autocmd BufWritePost *.py call Flake8()
" }}}

" FZF {{{
nnoremap <C-a> :Ag<cr>
nnoremap <leader><C-p> :Files<cr>
nnoremap <leader><C-s> :GFiles?<cr>
nnoremap <C-p> :GFiles<cr>
set rtp+=/usr/local/opt/fzf
" }}}

" NERDTree {{{
let NERDTreeIgnore = ['\.pyc$']
nmap <leader>d :NERDTreeToggle<CR>
" }}}

" Rails {{{
nmap <silent> <leader>t :Rake<CR>
" }}}

" Supertab {{{
let g:SuperTabDefaultCompletionType = "context"
" }}}

" Test.vim {{{
let test#strategy = "dispatch"
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-m> :TestNearest<CR>
" }}}
" }}}

-- -------------------------------------
--  General settings
-- -------------------------------------

-- Whitespace handling

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = true

-- Editing

vim.opt.formatoptions:append("cjqrn1")
vim.opt.showmatch = true
vim.opt.textwidth = 120

-- Visual

vim.opt.colorcolumn = "120"
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true

-- Search

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- Splits

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Other

vim.opt.confirm = true
vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.scrolloff = 3
vim.opt.wildmenu = true
vim.opt.wildignore:append("*/.git/*,*/.hg/*,*.pyc")
vim.opt.visualbell = true
vim.opt.backspace:append("indent,eol,start")
vim.opt.completeopt:append("menuone,longest,preview")
vim.opt.clipboard:append("unnamedplus")

vim.g.markdown_fenced_languages = {'swift', 'python', 'ruby', 'javascript', 'typescript'}

-- -------------------------------------
-- Key mappings
-- -------------------------------------

function map(mode, shortcut, command, options)
  local opts = { noremap = true }
  if options then
    opts = vim.tbl_extend('force', opts, options)
  end
  vim.keymap.set(mode, shortcut, command, opts)
end

function imap(shortcut, command, options)
  map('i', shortcut, command, options)
end

function nmap(shortcut, command, options)
  map('n', shortcut, command, options)
end

function vmap(shortcut, command, options)
  map('v', shortcut, command, options)
end

-- Open a terminal (shell)
nmap("<leader>s", ":split term://zsh<CR>", { noremap = false, silent = true })
nmap("<leader>S", ":vsplit term://zsh<CR>", { noremap = false, silent = true })

-- Unhighlight search results
nmap("<leader><space>", ":nohlsearch<CR>")

-- Position search matches in the middle of the window
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Fast tab switching
map('', '<leader>1', '1gt')
map('', '<leader>2', '2gt')
map('', '<leader>3', '3gt')
map('', '<leader>4', '4gt')
map('', '<leader>5', '5gt')
map('', '<leader>0', ':tablast<CR>')

-- Go to last active tab
vim.api.nvim_create_autocmd("TabLeave", {
  command = "let g:lasttab = tabpagenr()"
})
nmap("<c-l>", ":exe \"tabn \".g:lasttab<CR>", { noremap = true, silent = true })
vmap("<c-l>", ":exe \"tabn \".g:lasttab<CR>", { noremap = true, silent = true })

-- Use / as a search short-cut
nmap("/", "/\\v")

-- Folding
nmap("<leader>z", ":setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<cr>")

-- Zoom a Vim pane, <C-w>= to re-balance
nmap("<leader>-", ":wincmd _<CR>:wincmd |<CR>")
nmap("<leader>=", ":wincmd =<CR>")

-- Ruby bindings

local rubyGroup = vim.api.nvim_create_augroup("Ruby", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(opts)
    nmap("<leader>b", "Obinding.pry<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(opts)
    nmap("<leader>B", "Obyebug<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(opts)
    nmap("<leader>d", "Odebugger<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(opts)
    nmap("<leader>F", "ggO# frozen_string_literal: true<cr><esc>0D")
  end
})

if vim.fn.executable('pbcopy') == 1 then
  -- Copy current file name to the clipboard
  nmap("<leader>f", ":!echo -n % | pbcopy<CR><CR>")
end

-- -------------------------------------
--  Plugins
-- ------------------------------------

local Plug = vim.fn['plug#']
local plugin_dir = vim.fn.stdpath('data') .. '/site/plugins/'

vim.g.ale_disable_lsp = 1

vim.call('plug#begin', plugin_dir)

Plug 'dense-analysis/ale'
Plug 'github/copilot.vim'
Plug 'tanvirtin/monokai.nvim'
Plug 'preservim/nerdtree'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'rust-lang/rust.vim'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
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
Plug('Shopify/vim-sorbet', { branch = 'master' })
Plug 'tpope/vim-surround'
Plug 'vim-test/vim-test'

if vim.fn.has("macunix") then
  Plug 'rizzatti/dash.vim'
end

vim.call('plug#end')

if vim.fn.isdirectory(plugin_dir) == 0 then
  vim.fn.mkdir(plugin_dir)
  vim.cmd('PlugInstall')
end

-- =====================================
--  Plugin configuration
-- =====================================

-- -------------------------------------
-- Ale
-- -------------------------------------
vim.g.ale_fixers = {
      ruby = {'rubocop'},
      rust = {'rustfmt'},
}

vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_text_changed = 1
vim.g.ale_open_list = 0
vim.g.ale_ruby_rubocop_executable = 'bin/rubocop'
vim.g.ale_set_loclist = 0
vim.g.ale_set_quickfix = 0

-- -------------------------------------
-- Neovim LSP
-- -------------------------------------

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150,
}

require('lspconfig')['rust_analyzer'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
require'lspconfig'.solargraph.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["solargraph"] = {}
    }
}

require('lspconfig')['sorbet'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
}

local _border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.diagnostic.config {
  float = { border = _border },
}

-- -------------------------------------
-- Copilot
-- -------------------------------------
if vim.fn.filereadable('/usr/local/Cellar/node@16/16.18.1/bin/node') then
  vim.g.copilot_node_command = "/usr/local/Cellar/node@16/16.18.1/bin/node"
end
if vim.fn.filereadable('/opt/homebrew/opt/node@16/bin/node') then
  vim.g.copilot_node_command = "/opt/homebrew/opt/node@16/bin/node"
end
if vim.fn.filereadable('/usr/local/bin/node') then
  vim.g.copilot_node_command = "/usr/local/bin/node"
end

-- -------------------------------------
-- Dash
-- -------------------------------------
if vim.fn.has("macunix") then
  nmap("<leader>h", "<Plug>DashSearch", { silent = true, noremap = true })
end

-- -------------------------------------
-- monokai.nvim
-- -------------------------------------
vim.o.termguicolors = true
require('monokai').setup {}

vim.api.nvim_set_hl(0, 'CocFloating', { guibg = Grey })

-- -------------------------------------
-- NERDTree
-- -------------------------------------
nmap('<leader>T', ':NERDTreeFocus<CR>', { silent = true, noremap = true})

-- -------------------------------------
-- rust.vim
-- -------------------------------------
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0

-- -------------------------------------
-- telescope
-- -------------------------------------
nmap('<C-a>', '<cmd>Telescope find_files<cr>')
nmap('<C-p>', '<cmd>Telescope git_files<cr>')

-- -------------------------------------
-- vim-airline/vim-airline-themes
-- -------------------------------------
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'minimalist'

-- -------------------------------------
-- vim-json
-- -------------------------------------
vim.g.vim_json_syntax_conceal = 0

-- -------------------------------------
-- vim-test
-- -------------------------------------
vim.g['test#strategy'] = 'dispatch'

nmap('<leader>t', ':TestFile<CR>', { silent = true, noremap = true })
nmap('<leader>l', ':TestLast<CR>', { silent = true, noremap = true })
nmap('<leader>n', ':TestNearest<CR>', { silent = true, noremap = true })

vim.api.nvim_create_autocmd("TermOpen", {
  command = "DisableWhitespace"
})
vim.api.nvim_create_autocmd("TermOpen", {
  command = "startinsert"
})

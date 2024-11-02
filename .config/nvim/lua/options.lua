-- [[ Setting options ]]
-- See `:help opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

local opt = vim.opt

-- Whitespace handling

opt.autoindent = true
opt.tabstop = 2
opt.shiftround = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.wrap = true
opt.breakindent = true

-- Editing

opt.formatoptions:append 'cjqrn1'
opt.showmatch = true
opt.textwidth = 120

-- Visual

opt.colorcolumn = '120'
opt.cursorline = true
opt.laststatus = 2
opt.number = true
opt.relativenumber = true
opt.showcmd = true
opt.showmode = false
opt.signcolumn = 'yes'
opt.termguicolors = true

-- Search

opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

-- Splits

opt.splitbelow = true
opt.splitright = true

-- Other

opt.confirm = true
opt.mouse = 'a'
opt.encoding = 'utf-8'
opt.scrolloff = 3
opt.wildmenu = true
opt.wildignore:append '*/.git/*,*/.hg/*,*.pyc'
opt.visualbell = true
opt.backspace:append 'indent,eol,start'
opt.completeopt:append 'menuone,longest,preview'
opt.undofile = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Decrease swap file update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

vim.g.python3_host_prog = '/Users/brad/.virtualenvs/neovim/bin/python3'

-- vim: ts=2 sts=2 sw=2 et

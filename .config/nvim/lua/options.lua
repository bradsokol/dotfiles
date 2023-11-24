local opt = vim.opt
local g = vim.g

-- Whitespace handling

opt.autoindent = true
opt.tabstop = 2
opt.shiftround = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.wrap = true

-- Editing

opt.formatoptions:append("cjqrn1")
opt.showmatch = true
opt.textwidth = 120

-- Visual

opt.colorcolumn = "120"
opt.cursorline = true
opt.laststatus = 2
opt.number = true
opt.relativenumber = true
opt.showcmd = true
opt.showmode = true

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
opt.mouse = "a"
opt.encoding = "utf-8"
opt.scrolloff = 3
opt.wildmenu = true
opt.wildignore:append("*/.git/*,*/.hg/*,*.pyc")
opt.visualbell = true
opt.backspace:append("indent,eol,start")
opt.completeopt:append("menuone,longest,preview")
opt.clipboard:append("unnamedplus")

g.markdown_fenced_languages = {'swift', 'python', 'ruby', 'javascript', 'typescript'}

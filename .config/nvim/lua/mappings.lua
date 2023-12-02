local utils = require("utils")
local imap = utils.imap
local map = utils.map
local nmap = utils.nmap
local vmap = utils.vmap

local api = vim.api

-- Copilot completion
imap('<C-L>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false })

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
api.nvim_create_autocmd("TabLeave", {
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

-- Quickfix navigation
nmap("[q", ":cprev<CR>")
nmap("]q", ":cnext<CR>")

-- Ruby bindings

local rubyGroup = api.nvim_create_augroup("Ruby", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>b", "Obinding.pry<esc>==")
  end
})
api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>B", "Obyebug<esc>==")
  end
})
api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>dd", "Odebugger<esc>==")
  end
})
api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>F", "ggO# frozen_string_literal: true<cr><esc>0D")
  end
})

if vim.fn.executable('pbcopy') == 1 then
  -- Copy current file name to the clipboard
  nmap("<leader>f", ":!echo -n % | pbcopy<CR><CR>")
end

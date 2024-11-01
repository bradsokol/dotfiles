vim.keymap.set('n', '<Leader>s', ':split term://zsh<cr>', { desc = 'Horizontal terminal split' })
vim.keymap.set('n', '<Leader>S', ':vsplit term://zsh<cr>', { noremap = false, silent = true, desc = 'Vertical terminal split' })

vim.keymap.set('n', '<Leader><space>', ':nohlsearch<cr>', { desc = 'Unhighlight search results' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result to middle' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result to middle' })

-- Fast tab switching
vim.keymap.set('', '<Leader>1', '1gt', { desc = 'Go to tab 1' })
vim.keymap.set('', '<Leader>2', '2gt', { desc = 'Go to tab 2' })
vim.keymap.set('', '<Leader>3', '3gt', { desc = 'Go to tab 3' })
vim.keymap.set('', '<Leader>4', '4gt', { desc = 'Go to tab 4' })
vim.keymap.set('', '<Leader>5', '5gt', { desc = 'Go to tab 5' })
vim.keymap.set('', '<Leader>0', ':tablast<cr>', { desc = 'Go to last tab' })

-- Go to last active tab
vim.api.nvim_create_autocmd('TabLeave', {
  command = 'let g:lasttab = tabpagenr()',
})
vim.keymap.set('n', '<c-l>', ':exe "tabn ".g:lasttab<CR>', { noremap = true, silent = true, desc = 'Go to last active tab' })
vim.keymap.set('v', '<c-l>', ':exe "tabn ".g:lasttab<CR>', { noremap = true, silent = true, desc = 'Go to last active tab' })

-- Zoom a Vim pane, <C-w>= to re-balance
vim.keymap.set('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>', { desc = 'Zoom pane' })
vim.keymap.set('n', '<leader>=', ':wincmd =<CR>', { desc = 'Unzoom pane' })

-- Quickfix navigation
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Previous quickfix entry' })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next quickfix entry' })

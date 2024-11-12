vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Floating terminal' })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal size=10<cr>', { desc = 'Horizontal terminal split' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', { desc = 'Vertical terminal split' })

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

-- LSP actions
vim.keymap.set({ 'n', 'x' }, '<leader>la', function()
  vim.lsp.buf.code_action()
end, { desc = 'LSP code action' })
vim.keymap.set('n', '<leader>lA', function()
  vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } }
end, { desc = 'LSP source action' })

vim.keymap.set('n', '<leader>ll', function()
  vim.lsp.codelens.refresh()
end, { desc = 'LSP CodeLens refresh' })
vim.keymap.set('n', '<leader>lL', function()
  vim.lsp.codelens.run()
end, { desc = 'LSP CodeLens run' })

vim.keymap.set('n', 'gd', function()
  vim.lsp.buf.definition()
end, { desc = 'Show the definition of current symbol' })
vim.keymap.set('n', 'gD', function()
  vim.lsp.buf.declaration()
end, { desc = 'Declaration of current symbol' })

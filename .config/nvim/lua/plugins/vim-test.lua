return {
  'vim-test/vim-test',
  config = function()
    vim.g['test#strategy'] = 'dispatch'

    vim.api.nvim_create_autocmd("TermOpen", {
      command = "DisableWhitespace"
    })
    vim.api.nvim_create_autocmd("TermOpen", {
      command = "startinsert"
    })

    local keymap = vim.keymap
    keymap.set('n', '<leader>t', ':TestFile<CR>', { noremap = true, silent = true })
    keymap.set('n', '<leader>l', ':TestLast<CR>', { noremap = true, silent = true })
    keymap.set('n', '<leader>n', ':TestNearest<CR>', { noremap = true, silent = true })
  end,
}

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>b', 'Obinding.break<esc>==', { desc = 'Call debugger break' })

vim.keymap.set('n', '<leader>Tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Floating terminal' })
vim.keymap.set('n', '<leader>Th', '<cmd>ToggleTerm direction=horizontal size=10<cr>', { desc = 'Horizontal terminal split' })
vim.keymap.set('n', '<leader>Tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', { desc = 'Vertical terminal split' })

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
vim.keymap.set('n', '<c-t>', ':exe "tabn ".g:lasttab<CR>', { noremap = true, silent = true, desc = 'Go to last active tab' })
vim.keymap.set('v', '<c-t>', ':exe "tabn ".g:lasttab<CR>', { noremap = true, silent = true, desc = 'Go to last active tab' })

-- Zoom a Vim pane, <C-w>= to re-balance
vim.keymap.set('n', '<leader>-', ':wincmd _<CR>:wincmd |<CR>', { desc = 'Zoom pane' })
vim.keymap.set('n', '<leader>=', ':wincmd =<CR>', { desc = 'Unzoom pane' })

-- Quickfix navigation
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Previous quickfix entry' })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next quickfix entry' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float {
      scope = 'cursor',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    }
  end,
})

-- Configure indent-blankline
local scope = 'focus'
local indent = 'passive'

local hooks = require 'ibl.hooks'

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, 'focus', { fg = '#7486bd' })
  vim.api.nvim_set_hl(0, 'passive', { fg = '#41425e' })
end)

require('ibl').setup {
  scope = { highlight = scope },
  indent = { highlight = indent },
}

-- Use diagnostic symbols in the sign column (gutter)
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'Error',
      [vim.diagnostic.severity.WARN] = 'Warn',
      [vim.diagnostic.severity.HINT] = 'Hint',
      [vim.diagnostic.severity.INFO] = 'Info',
    },
  },
}

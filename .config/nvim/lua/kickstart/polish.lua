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
require('lualine').setup {
  options = {
    theme = 'solarized_dark',
  },
}

local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

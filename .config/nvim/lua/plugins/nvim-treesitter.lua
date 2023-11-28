return {
  'nvim-treesitter/nvim-treesitter',
  enabled = false,
  event = { 'BufRead', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter.configs')

    treesitter.setup({
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        'json',
        'javascript',
        'typescript',
        'tsx',
        'html',
        'css',
        'markdown',
        'graphql',
        'ruby',
        'swift',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    })
  end,
}

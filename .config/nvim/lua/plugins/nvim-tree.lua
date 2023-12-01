return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  keys = {
    { '<leader>T', ':NvimTreeFindFileToggle<cr>', desc = 'Toggle file explorer' },
  },
  config = function()
    vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
    vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

    local function on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      diagnostics = {
        enable = true,
      },
      filters = {
        custom = { ".DS_Store", "^.git$" },
        dotfiles = true,
      },
      git = {
        ignore = true,
      },
      renderer = {
        group_empty = true,
        indent_markers = {
          enable = true,
        },
      },
      view = {
        relativenumber = true,
        width = 35,
      },
    })
  end,
}

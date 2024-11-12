return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'solarized_light',
        tabline = {
          lualine_a = {
            'tabs',
            mode = 2,
            -- fmt = function(name, context)
            --   -- Show + if buffer is modified in tab
            --   local buflist = vim.fn.tabpagebuflist(context.tabnr)
            --   local winnr = vim.fn.tabpagewinnr(context.tabnr)
            --   local bufnr = buflist[winnr]
            --   local mod = vim.fn.getbufvar(bufnr, '&mod')
            --
            --   return context.tabnr .. name .. (mod == 1 and ' ' or '')
            -- end,
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      },
      -- tabline = {
      --   lualine_a = {},
      --   lualine_b = { 'filename' },
      --   lualine_c = {},
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
      -- winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { 'filename' },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
      -- inactive_winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { 'filename' },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
    }
  end,
}

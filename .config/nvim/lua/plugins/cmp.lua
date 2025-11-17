 -- Autocompletion
 -- https://github.com/hrsh7th/nvim-cmp/
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- Snippet engine
        -- https://github.com/L3MON4D3/LuaSnip
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            -- Premade snippets
            -- https://github.com/rafamadriz/friendly-snippets
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      -- Integrate snippets into nvim-cmp
      -- https://github.com/saadparwaiz1/cmp_luasnip
      'saadparwaiz1/cmp_luasnip',

      -- Integrate Neovim's LSP with nvim-cmp
      -- https://github.com/hrsh7th/cmp-nvim-lsp/
      'hrsh7th/cmp-nvim-lsp',

      -- Add file system paths to nvim-cmp
      -- https://github.com/hrsh7th/cmp-path
      'hrsh7th/cmp-path',

      -- VS Code-style pictograms for nvim-cmp
      -- https://github.com/onsails/lspkind.nvim
      'onsails/lspkind.nvim',
      {
        -- Integrate copilot.lua with nvim-cmp
        -- https://github.com/zbirenbaum/copilot-cmp
        'zbirenbaum/copilot-cmp',
        config = function()
          require('copilot_cmp').setup()
        end,
      },
    },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- See `:help ins-completion` for background
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'copilot', group_index = 2 },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },

        formatting = {
          expandable_indicator = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format {
            mode = 'symbol',
            maxwidth = {
              abbr = 50,
              menu = 50,
            },
            ellipsis_char = '...',
            show_labelDetails = true,
            symbol_map = { Copilot = '' },
          },
        },
      }
    end,
  },
}

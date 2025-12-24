-- LSP Plugins
return {
  {
    -- Configures Lua LSP for your Neovim config, runtime and plugins
    -- https://github.com/folke/lazydev.nvim
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Quickstart configs for Neovim's LSP support
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Package manager for installing LSP servers, DAP server, linters and formatters
      -- https://github.com/mason-org/mason.nvim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      -- https://github.com/mason-org/mason-lspconfig.nvim
      'williamboman/mason-lspconfig.nvim',
      -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      {
        -- UI for notifications and LSP messages
        -- https://github.com/j-hui/fidget.nvim
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            override_vim_notify = false,
            window = {
              normal_hl = 'String',
              winblend = 0,
              border = 'rounded',
              zindex = 45,
              max_width = 0,
              max_height = 0,
              x_padding = 1,
              y_padding = 1,
              align = 'bottom',
              relative = 'editor',
            },
          },
        },
      },

      -- Allows extra capabilities provided by nvim-cmp
      -- https://github.com/hrsh7th/cmp-nvim-lsp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gT', require('telescope.builtin').lsp_type_definitions, '[Goto] [T]ype Definition')
          map('<leader>fs', require('telescope.builtin').lsp_document_symbols, '[Find] [S]ymbols')
          map('<leader>fw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Highlight references of the word under your cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Keymap to toggle inlay hints in your code, if the language server you are using supports them
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Enable language servers. Override default configuration with the following keys:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      local servers = {
        clangd = {},
        basedpyright = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
        },
        ruby_lsp = {
          cmd = { 'ruby-lsp' },
          filetypes = { 'ruby' },
          root_dir = require('lspconfig.util').root_pattern('.git', 'Gemfile', '.'),
          settings = {},
        },
        rust_analyzer = {},
      }

      -- Ensure the servers and tools above are installed
      require('mason').setup {
        ui = {
          border = 'rounded',
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'black',
        'clangd',
        'isort',
        'prettier',
        'pylint',
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            if server_name == 'sorbet' then
              server.root_dir = require('lspconfig.util').root_pattern 'sorbet/config'
            end

            vim.lsp.config(server_name).setup(server)
          end,
        },
      }

      vim.lsp.enable 'sourcekit'
      vim.lsp.config('sourcekit', {
        capabilities = capabilities,
        root_dir = function(_, callback)
          callback(
            require('lspconfig.util').root_pattern 'Package.swift'(vim.fn.getcwd())
              or vim.fs.dirname(vim.fs.find('.git', { path = vim.fn.getcwd(), upward = true })[1])
          )
        end,
      })

      vim.diagnostic.config {
        virtual_lines = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
      }
      require('lspconfig.ui.windows').default_options.border = 'rounded'
    end,
  },
}

return {
  'neovim/nvim-lspconfig',
  event = { 'BufNewFile', 'BufReadPre' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'folke/lsp-trouble.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local opts = { noremap=true, silent=true }
    local keymap = vim.keymap

    require('trouble').setup {
      auto_open = false,
      auto_close = true,
      use_diagnostic_signs = true,
    }

    keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    local on_attach = function(_, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local config = {
      virtual_text = false,
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })

    local lsp_flags = {
      debounce_text_changes = 150,
    }

    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach,
    })

    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    lspconfig["html"].setup({
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach,
    })

    local _timers = {}
    local function setup_diagnostics(client, buffer)
      if require("vim.lsp.diagnostic")._enable then
        return
      end

      local diagnostic_handler = function()
        local params = vim.lsp.util.make_text_document_params(buffer)
        client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
          if err then
            local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
            vim.lsp.log.error(err_msg)
          end
          local diagnostic_items = {}
          if result then
            diagnostic_items = result.items
          end
          vim.lsp.diagnostic.on_publish_diagnostics(
          nil,
          vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
          { client_id = client.id }
          )
        end)
      end

      diagnostic_handler() -- to request diagnostics on buffer when first attaching

      vim.api.nvim_buf_attach(buffer, false, {
        on_lines = function()
          if _timers[buffer] then
            vim.fn.timer_stop(_timers[buffer])
          end
          _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
        end,
        on_detach = function()
          if _timers[buffer] then
            vim.fn.timer_stop(_timers[buffer])
          end
        end,
      })
    end

    require("lspconfig").ruby_ls.setup({
      on_attach = function(client, buffer)
        setup_diagnostics(client, buffer)
      end,
      root_dir = require("lspconfig.util").find_git_ancestor
    })

    lspconfig['sorbet'].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
      root_dir = require("lspconfig.util").root_pattern("sorbet/config"),
    }

    if vim.fn.has("macunix") then
      lspconfig["sourcekit"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        cmd = {
          "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
        },
        root_dir = function(filename, _)
          return util.root_pattern("buildServer.json")(filename) or
          util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename) or
          util.find_git_ancestor(filename) or
          util.root_pattern("Package.swift")(filename)
        end,
      })
    end

    lspconfig['tsserver'].setup({
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = _border
    }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = _border
    }
    )

    vim.diagnostic.config {
      float = { border = _border },
    }
  end,
}

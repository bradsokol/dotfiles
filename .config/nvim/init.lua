-- -------------------------------------
--  General settings
-- -------------------------------------

-- Whitespace handling

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = true

-- Editing

vim.opt.formatoptions:append("cjqrn1")
vim.opt.showmatch = true
vim.opt.textwidth = 120

-- Visual

vim.opt.colorcolumn = "120"
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true

-- Search

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- Splits

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Other

vim.opt.confirm = true
vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.scrolloff = 3
vim.opt.wildmenu = true
vim.opt.wildignore:append("*/.git/*,*/.hg/*,*.pyc")
vim.opt.visualbell = true
vim.opt.backspace:append("indent,eol,start")
vim.opt.completeopt:append("menuone,longest,preview")
vim.opt.clipboard:append("unnamedplus")

vim.g.markdown_fenced_languages = {'swift', 'python', 'ruby', 'javascript', 'typescript'}

-- -------------------------------------
-- Key mappings
-- -------------------------------------

local function map(mode, shortcut, command, options)
  local opts = { noremap = true }
  if options then
    opts = vim.tbl_extend('force', opts, options)
  end
  vim.keymap.set(mode, shortcut, command, opts)
end

local function imap(shortcut, command, options)
  map('i', shortcut, command, options)
end

local function nmap(shortcut, command, options)
  map('n', shortcut, command, options)
end

local function vmap(shortcut, command, options)
  map('v', shortcut, command, options)
end

-- Copilot completion
imap('<C-L>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false })

-- Open a terminal (shell)
nmap("<leader>s", ":split term://zsh<CR>", { noremap = false, silent = true })
nmap("<leader>S", ":vsplit term://zsh<CR>", { noremap = false, silent = true })

-- Unhighlight search results
nmap("<leader><space>", ":nohlsearch<CR>")

-- Position search matches in the middle of the window
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Fast tab switching
map('', '<leader>1', '1gt')
map('', '<leader>2', '2gt')
map('', '<leader>3', '3gt')
map('', '<leader>4', '4gt')
map('', '<leader>5', '5gt')
map('', '<leader>0', ':tablast<CR>')

-- Go to last active tab
vim.api.nvim_create_autocmd("TabLeave", {
  command = "let g:lasttab = tabpagenr()"
})
nmap("<c-l>", ":exe \"tabn \".g:lasttab<CR>", { noremap = true, silent = true })
vmap("<c-l>", ":exe \"tabn \".g:lasttab<CR>", { noremap = true, silent = true })

-- Use / as a search short-cut
nmap("/", "/\\v")

-- Folding
nmap("<leader>z", ":setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<cr>")

-- Zoom a Vim pane, <C-w>= to re-balance
nmap("<leader>-", ":wincmd _<CR>:wincmd |<CR>")
nmap("<leader>=", ":wincmd =<CR>")

-- Quickfix navigation
nmap("[q", ":cprev<CR>")
nmap("]q", ":cnext<CR>")

-- Ruby bindings

local rubyGroup = vim.api.nvim_create_augroup("Ruby", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>b", "Obinding.pry<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>B", "Obyebug<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>d", "Odebugger<esc>==")
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = rubyGroup,
  callback = function(_)
    nmap("<leader>F", "ggO# frozen_string_literal: true<cr><esc>0D")
  end
})

if vim.fn.executable('pbcopy') == 1 then
  -- Copy current file name to the clipboard
  nmap("<leader>f", ":!echo -n % | pbcopy<CR><CR>")
end

-- -------------------------------------
--  Plugins
-- ------------------------------------

local Plug = vim.fn['plug#']
local plugin_dir = vim.fn.stdpath('data') .. '/site/plugins/'

vim.call('plug#begin', plugin_dir)

Plug 'github/copilot.vim'
Plug 'tanvirtin/monokai.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jparise/vim-graphql'
Plug 'elzr/vim-json'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug('Shopify/vim-sorbet', { branch = 'master' })
Plug 'tpope/vim-surround'
Plug 'vim-test/vim-test'
Plug 'stevearc/dressing.nvim'

-- nvim-tree
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

-- nvim-cmp
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')
Plug('rafamadriz/friendly-snippets')
Plug('onsails/lspkind.nvim')

-- lsp
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('williamboman/mason-lspconfig.nvim')
Plug('WhoIsSethDaniel/mason-tool-installer.nvim')
Plug('williamboman/mason.nvim')

if vim.fn.has("macunix") then
  Plug 'rizzatti/dash.vim'
end

vim.call('plug#end')

if vim.fn.isdirectory(plugin_dir) == 0 then
  vim.fn.mkdir(plugin_dir)
  vim.cmd('PlugInstall')
end

-- =====================================
--  Plugin configuration
-- =====================================

-- -------------------------------------
-- nvim-tree
-- -------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
 nmap('<leader>T', ':NvimTreeToggle<CR>', { silent = true, noremap = true})

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

require("nvim-tree").setup({
  on_attach = on_attach,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- -------------------------------------
-- nvim-cmp
-- -------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").load()

local check_backspace = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

--   פּ ﯟ   some other good icons
-- See https://github.com/LunarVim/Neovim-from-scratch/blob/a0e07fcba9be979ae2594636a32c881064a3c8f6/lua/user/cmp.lua#L97-L110
local kind_icons = {
  Text = "󰊄",
  Method = "m",
  Function = "󰊕",
  Constructor = "",
  Field = "",
  Variable = "󰫧",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "󰌆",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "󰉺",
}

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,preview,noselect',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      vim_item.menu = ({
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

-- -------------------------------------
--  Mason
-- -------------------------------------

local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local mason_tool_installer = require('mason-tool-installer')

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "lua_ls",
    "graphql",
    "ruby_ls",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

mason_tool_installer.setup({
  ensure_installed = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "eslint_d", -- js linter
  },
})

-- -------------------------------------
-- Neovim LSP
-- -------------------------------------

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
local keymap = vim.keymap

keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

on_attach = function(_, bufnr)
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
  virtual_text = true,
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
})

lspconfig['sorbet'].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}

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

-- -------------------------------------
-- Copilot
-- -------------------------------------
if vim.fn.has("macunix") == 1 then
  vim.g.copilot_node_command = "/opt/homebrew/opt/node/bin/node"
else
  if vim.fn.has("linux") == 1 then
    vim.g.copilot_node_command = "/usr/local/bin/node"
  end
end

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- -------------------------------------
-- Dash
-- -------------------------------------
if vim.fn.has("macunix") then
  nmap("<leader>h", "<Plug>DashSearch", { silent = true, noremap = true })
end

-- -------------------------------------
-- monokai.nvim
-- -------------------------------------
vim.o.termguicolors = true
require('monokai').setup {}

-- -------------------------------------
-- telescope
-- -------------------------------------
-- Old mappings
nmap('<C-a>', '<cmd>Telescope live_grep<cr>')
nmap('<C-p>', '<cmd>Telescope git_files<cr>')

nmap('<leader>ff', '<cmd>Telescope git_files<cr>')
nmap('<leader>fF', '<cmd>Telescope find_files<cr>')
nmap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
nmap('<leader>fh', '<cmd>Telescope help_tags<cr>')

-- -------------------------------------
-- vim-airline/vim-airline-themes
-- -------------------------------------
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'minimalist'

-- -------------------------------------
-- vim-json
-- -------------------------------------
vim.g.vim_json_syntax_conceal = 0

-- -------------------------------------
-- vim-test
-- -------------------------------------
vim.g['test#strategy'] = 'dispatch'

nmap('<leader>t', ':TestFile<CR>', { silent = true, noremap = true })
nmap('<leader>l', ':TestLast<CR>', { silent = true, noremap = true })
nmap('<leader>n', ':TestNearest<CR>', { silent = true, noremap = true })

vim.api.nvim_create_autocmd("TermOpen", {
  command = "DisableWhitespace"
})
vim.api.nvim_create_autocmd("TermOpen", {
  command = "startinsert"
})

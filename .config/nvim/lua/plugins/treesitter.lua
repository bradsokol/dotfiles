-- Integration with Treesitter parser
-- https://github.com/nvim-treesitter/nvim-treesitter (main branch)

local ensure = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'ruby',
  'vim',
  'vimdoc',
}

if vim.fn.executable 'swift' == 1 then
  table.insert(ensure, 'swift')
end

-- Some languages depend on vim's regex highlighting system for indent rules.
-- Keep regex highlighting on and Treesitter indent off for these.
local regex_highlight = { ruby = true }
local no_ts_indent = { ruby = true }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install(ensure)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          local function enable()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end
            if not pcall(vim.treesitter.start, args.buf, lang) then
              return
            end
            if regex_highlight[lang] then
              vim.bo[args.buf].syntax = 'ON'
            end
            if not no_ts_indent[lang] then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          if vim.list_contains(ts.get_installed 'parsers', lang) then
            enable()
          elseif available[lang] then
            -- Equivalent of the old `auto_install = true`
            ts.install(lang):await(function()
              vim.schedule(enable)
            end)
          end
        end,
      })
    end,
  },
}

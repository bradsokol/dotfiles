-- Integration with Treesitter parser
-- https://github.com/nvim-treesitter/nvim-treesitter

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

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      endwise = { enable = true },
      ensure_installed = ensure,
      auto_install = true,
      -- Hide Ruby Sorbet signatures
      hidesig = {
        enable = true,
        opacity = 0.75,
        delay = 200,
      },
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}

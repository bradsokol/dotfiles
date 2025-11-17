-- Integration with Treesitter parser
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      endwise = { enable = true },
      ensure_installed = {
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
        'swift',
        'vim',
        'vimdoc',
      },
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

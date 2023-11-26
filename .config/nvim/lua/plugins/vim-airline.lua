return {
  'vim-airline/vim-airline',
  dependencies = { 'vim-airline/vim-airline-themes' },
  config = function()
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_theme = 'minimalist'
  end
}

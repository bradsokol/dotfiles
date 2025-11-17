-- Manages terminal toggling within Neovim
-- https://github.com/akinsho/toggleterm.nvim
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    cmd = { 'ToggleTerm', 'TermExec' },
  },
}

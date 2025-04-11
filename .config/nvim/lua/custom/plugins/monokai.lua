return {
  'loctvl842/monokai-pro.nvim',
  config = function()
    require('monokai-pro').setup {
      devicons = true,
      filter = 'machine',
    }
    vim.cmd [[MonokaiPro machine]]
  end,
}

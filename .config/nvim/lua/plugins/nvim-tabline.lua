return {
  'seblj/nvim-tabline',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('tabline').setup({
      options = {
        show_tab_indicators = true,
        show_close_icon = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        max_bufferline_percent = 66,
      },
    })
  end,
}

return {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  keys = {
    {'<C-a>', '<cmd>Telescope live_grep<cr>', desc = 'Live grep'},
    {'<C-p>', '<cmd>Telescope git_files<cr>', desc = 'Git files'},
    {'<leader>ff', '<cmd>Telescope git_files<cr>', desc = 'Git files'},
    {'<leader>fF', '<cmd>Telescope find_files<cr>', desc = 'Find files'},
    {'<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep'},
    {'<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find in buffers'},
    {'<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Find in help'},
  },
}


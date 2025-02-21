return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'zidhuss/neotest-minitest',
  },
  keys = {
    { '<leader>Ta', "<cmd>lua require('neotest').run.attach()<cr>", desc = 'Attach to the nearest test' },
    { '<leader>Tl', "<cmd>lua require('neotest').run.run_last()<cr>", desc = 'Toggle Test Summary' },
    { '<leader>To', "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = 'Toggle Test Output Panel' },
    { '<leader>Tp', "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Stop the nearest test' },
    { '<leader>Ts', "<cmd>lua require('neotest').summary.toggle()<cr>", desc = 'Toggle Test Summary' },
    { '<leader>Tt', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Run the nearest test' },
    {
      '<leader>TT',
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      desc = 'Run test the current file',
    },
    {
      '<leader>Td',
      function()
        require('neotest').run.run { suite = false, strategy = 'dap' }
      end,
      desc = 'Debug nearest test',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        ['neotest-python'] = {
          runner = 'pytest',
        },
        require 'neotest-minitest',
      },
      log_level = 'debug',
    }
  end,
}

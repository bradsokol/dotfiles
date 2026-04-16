-- Debug Adapter Protocol client for Neovim
-- https://github.com/mfussenegger/nvim-dap
local dependencies = {
  -- Virtual text support
  -- https://github.com/theHamsta/nvim-dap-virtual-text
  'theHamsta/nvim-dap-virtual-text',
  -- UI for DAP in Neovim
  -- https://github.com/rcarriga/nvim-dap-ui
  'rcarriga/nvim-dap-ui',

  -- https://github.com/nvim-neotest/nvim-nio
  'nvim-neotest/nvim-nio',
  -- https://github.com/mason-org/mason.nvim
  'williamboman/mason.nvim',
  -- https://github.com/jay-babu/mason-nvim-dap.nvim
  'jay-babu/mason-nvim-dap.nvim',
}

-- Add your own debuggers here
if vim.fn.executable 'python' then
  table.insert(dependencies, 'mfussenegger/nvim-dap-python')
end
if vim.fn.executable 'ruby' then
  table.insert(dependencies, 'suketa/nvim-dap-ruby')
end
if vim.fn.executable 'xcodebuild' then
  table.insert(dependencies, 'wojciech-kulik/xcodebuild.nvim')
end

return {
  'mfussenegger/nvim-dap',
  dependencies = dependencies,
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F6>', dap.pause, desc = 'Debug: Pause' },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      { '<F9>', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      { '<F17>', dap.terminal, desc = 'Debug: Terminate' },
      {
        '<F21>', -- Shift-F9
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Toggle Breakpoint (F9)' },
      { '<leader>dB', dap.clear_breakpoints, desc = 'Clear Breakpoints' },
      { '<leader>dc', dap.continue, desc = 'Continue (F5)' },
      {
        '<leader>dC',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Set Conditional Breakpoint (Shift-F9)',
      },
      { '<leader>dh', require('dap.ui.widgets').hover, desc = 'Debugger Hover' },
      { '<leader>di', dap.step_into, desc = 'Step Into (F1)' },
      { '<leader>do', dap.step_over, desc = 'Step Over (F2)' },
      { '<leader>dO', dap.step_out, desc = 'Step Out (F3)' },
      { '<leader>dp', dap.pause, desc = 'Pause (F6)' },
      { '<leader>dq', dap.close, desc = 'Close Session' },
      { '<leader>dQ', dap.terminate, desc = 'Terminate Session' },
      { '<leader>ds', dap.run_to_cursor, desc = 'Run to Cursor' },
      { '<leader>du', dapui.toggle, desc = 'Toggle Debugger UI' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      ensure_installed = {
        'debugpy',
      },
      require('dap-python').setup './.venv/bin/python',
      require('dap-ruby').setup(),
      require('xcodebuild.integrations.dap').setup(),
    }

    require('nvim-dap-virtual-text').setup {
      virt_text_pos = 'eol',
    }

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local namespace = vim.api.nvim_create_namespace 'dap-hlng'
    vim.api.nvim_set_hl(namespace, 'DapBreakpoint', { fg = '#ff0000', bg = '#ffffff' })
    vim.api.nvim_set_hl(namespace, 'DapLogPoint', { fg = '#eaeaeb', bg = '#ffffff' })
    vim.api.nvim_set_hl(namespace, 'DapStopped', { fg = '#eaeaeb', bg = '#ffffff' })

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

    require('dap-python').setup()

    local xcodebuild_dap = require 'xcodebuild.integrations.dap'
    xcodebuild_dap.setup()

    vim.keymap.set('n', '<leader>add', xcodebuild_dap.build_and_debug, { desc = 'Build & Debug' })
    vim.keymap.set('n', '<leader>adr', xcodebuild_dap.debug_without_build, { desc = 'Debug Without Building' })
    vim.keymap.set('n', '<leader>adt', xcodebuild_dap.debug_tests, { desc = 'Debug Tests' })
    vim.keymap.set('n', '<leader>adT', xcodebuild_dap.debug_class_tests, { desc = 'Debug Class Tests' })
    vim.keymap.set('n', '<leader>ab', xcodebuild_dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>aB', xcodebuild_dap.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
    vim.keymap.set('n', '<leader>adx', xcodebuild_dap.terminate_session, { desc = 'Terminate Debugger' })
  end,
}

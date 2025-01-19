-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'mfussenegger/nvim-dap-python',
    'suketa/nvim-dap-ruby',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
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
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'debugpy',
      },
      require('dap-ruby').setup {},
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
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
  end,
}

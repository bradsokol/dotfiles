return {
  'wojciech-kulik/xcodebuild.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'MunifTanjim/nui.nvim',
    -- "folke/snacks.nvim", -- (optional) to show previews
    -- "nvim-tree/nvim-tree.lua", -- (optional) to manage project files
    -- "stevearc/oil.nvim", -- (optional) to manage project files
    'nvim-treesitter/nvim-treesitter', -- (optional) for Quick tests support (required Swift parser)
  },
  config = function()
    local progress_handle

    require('xcodebuild').setup {
      show_build_progress_bar = false,
      logs = {
        auto_open_on_success_tests = false,
        auto_open_on_failed_tests = false,
        auto_open_on_success_build = false,
        auto_open_on_failed_build = false,
        auto_focus = false,
        auto_close_on_app_launch = true,
        only_summary = true,
        notify = function(message, severity)
          local fidget = require 'fidget'
          if progress_handle then
            progress_handle.message = message
            if not message:find 'Loading' then
              progress_handle:finish()
              progress_handle = nil
              if vim.trim(message) ~= '' then
                fidget.notify(message, severity)
              end
            end
          else
            fidget.notify(message, severity)
          end
        end,
        notify_progress = function(message)
          local progress = require 'fidget.progress'

          if progress_handle then
            progress_handle.title = ''
            progress_handle.message = message
          else
            progress_handle = progress.handle.create {
              message = message,
              lsp_client = { name = 'xcodebuild.nvim' },
            }
          end
        end,
      },
      code_coverage = {
        enabled = true,
      },

      vim.api.nvim_create_autocmd('User', {
        pattern = { 'XcodebuildBuildFinished', 'XcodebuildTestsFinished' },
        callback = function(event)
          if event.data.cancelled then
            return
          end

          if event.data.success then
            require('trouble').close()
          elseif not event.data.failedCount or event.data.failedCount > 0 then
            if next(vim.fn.getqflist()) then
              require('trouble').open 'quickfix'
            else
              require('trouble').close()
            end

            require('trouble').refresh()
          end
        end,
      }),
    }

    vim.keymap.set('n', '<leader>xA', '<cmd>XcodebuildPicker<cr>', { desc = 'Show Xcodebuild Actions' })
    vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Show Project Manager Actions' })

    vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
    vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Build For Testing' })
    vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })

    vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
    vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run Selected Tests' })
    vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run This Test Class' })

    vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
    vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle Code Coverage' })
    vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Show Code Coverage Report' })
    vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Toggle Test Explorer' })
    vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Show Failing Snapshots' })

    vim.keymap.set('n', '<leader>xD', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
    vim.keymap.set('n', '<leader>xp', '<cmd>XcodebuildSelectTestPlan<cr>', { desc = 'Select Test Plan' })
    vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Show QuickFix List' })

    vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix Line' })
    vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Show Code Actions' })

    local xcodebuild = require 'xcodebuild.integrations.dap'

    local codelldbPath = os.getenv 'HOME' .. '/.local/codelldb-darwin-arm64/extension/adapter/codelldb'
    xcodebuild.setup(codelldbPath)

    vim.keymap.set('n', '<leader>xdd', xcodebuild.build_and_debug, { desc = 'Build & Debug' })
    vim.keymap.set('n', '<leader>xdr', xcodebuild.debug_without_build, { desc = 'Debug Without Building' })
    vim.keymap.set('n', '<leader>xdt', xcodebuild.debug_tests, { desc = 'Debug Tests' })
    vim.keymap.set('n', '<leader>xdT', xcodebuild.debug_class_tests, { desc = 'Debug Class Tests' })
    vim.keymap.set('n', '<leader>xb', xcodebuild.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>xB', xcodebuild.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
  end,
}

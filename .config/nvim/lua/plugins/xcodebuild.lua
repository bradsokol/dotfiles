-- Build, debug and test projects using Apple's tool chains
-- https://github.com/wojciech-kulik/xcodebuild.nvim
return {
  'wojciech-kulik/xcodebuild.nvim',
  dependencies = {
    -- Uncomment a picker that you want to use, snacks.nvim might be additionally
    -- useful to show previews and failing snapshots.

    -- You must select at least one:
    'nvim-telescope/telescope.nvim',
    -- "ibhagwan/fzf-lua",
    -- "folke/snacks.nvim", -- (optional) to show previews

    'MunifTanjim/nui.nvim',
    -- 'nvim-tree/nvim-tree.lua', -- (optional) to manage project files
    -- 'stevearc/oil.nvim', -- (optional) to manage project files
    'nvim-treesitter/nvim-treesitter', -- (optional) for Quick tests support (required Swift parser)
  },
  config = function()
    require('xcodebuild').setup {
      logs = { -- build & test logs
        auto_open_on_success_tests = false, -- open logs when tests succeeded
        auto_open_on_failed_tests = false, -- open logs when tests failed
        auto_open_on_success_build = false, -- open logs when build succeeded
        auto_open_on_failed_build = false, -- open logs when build failed
        auto_close_on_app_launch = false, -- close logs when app is launched
        auto_close_on_success_build = false, -- close logs when build succeeded (only if auto_open_on_success_build=false)
        auto_focus = true, -- focus logs buffer when opened
        filetype = '', -- file type set for buffer with logs
        open_command = 'silent botright 20split {path}', -- command used to open logs panel. You must use {path} variable to load the log file
        logs_formatter = 'xcbeautify --disable-colored-output --disable-logging', -- command used to format logs, you can use "" to skip formatting
        only_summary = false, -- if true logs won't be displayed, just xcodebuild.nvim summary
        live_logs = true, -- if true logs will be updated in real-time
        show_warnings = true, -- show warnings in logs summary
        notify = function(message, severity) -- function to show notifications from this module (like "Build Failed")
          vim.notify(message, severity)
        end,
        notify_progress = function(message) -- function to show live progress (like during tests)
          vim.cmd("echo '" .. message .. "'")
        end,
      },
    }
    vim.keymap.set('n', '<leader>A', '<cmd>XcodebuildPicker<cr>', { desc = 'Show [A]pple (Xcode) Actions' })
    vim.keymap.set('n', '<leader>af', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Show Project Manager Actions' })

    vim.keymap.set('n', '<leader>ab', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
    vim.keymap.set('n', '<leader>aB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Build For Testing' })
    vim.keymap.set('n', '<leader>ar', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })

    vim.keymap.set('n', '<leader>at', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
    vim.keymap.set('v', '<leader>at', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run Selected Tests' })
    vim.keymap.set('n', '<leader>aT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run Current Test Class' })
    vim.keymap.set('n', '<leader>a.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Repeat Last Test Run' })

    vim.keymap.set('n', '<leader>al', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
    vim.keymap.set('n', '<leader>ac', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle Code Coverage' })
    vim.keymap.set('n', '<leader>aC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Show Code Coverage Report' })
    vim.keymap.set('n', '<leader>ae', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Toggle Test Explorer' })
    vim.keymap.set('n', '<leader>as', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Show Failing Snapshots' })

    vim.keymap.set('n', '<leader>ap', '<cmd>XcodebuildPreviewGenerateAndShow<cr>', { desc = 'Generate Preview' })
    vim.keymap.set('n', '<leader>a<cr>', '<cmd>XcodebuildPreviewToggle<cr>', { desc = 'Toggle Preview' })

    vim.keymap.set('n', '<leader>aD', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
    vim.keymap.set('n', '<leader>aq', '<cmd>Telescope quickfix<cr>', { desc = 'Show QuickFix List' })

    vim.keymap.set('n', '<leader>ax', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix Line' })
    vim.keymap.set('n', '<leader>aa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Show Code Actions' })
  end,
}

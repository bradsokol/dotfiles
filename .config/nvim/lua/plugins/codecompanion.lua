return {
  'olimorris/codecompanion.nvim',
  version = '^18.0.0',
  opts = {},
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      interactions = {
        chat = {
          adapter = 'claude_code',
          model = 'default',
        },
      },
      adapters = {
        acp = {
          opts = {
            show_presets = false,
          },
          claude_code = function()
            return require('codecompanion.adapters').extend('claude_code', {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_OAUTH,
              },
            })
          end,
        },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<C-c>', '<cmd>CodeCompanionActions<cr>', { desc = 'Open action pallette', noremap = true, silent = true })
    vim.keymap.set({ 'n', 'v' }, '<LocalLeader>Cc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle chat buffer', noremap = true, silent = true })
    vim.keymap.set('v', 'Ca', '<cmd>CodeCompanionChat Add<cr>', { desc = 'Add selection to chat', noremap = true, silent = true })
    vim.keymap.set('v', 'Ce', '<cmd>CodeCompanion /explain<cr>', { desc = 'Explain selected text', noremap = true, silent = true })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}

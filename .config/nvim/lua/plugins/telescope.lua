-- Fuzzy finder (files, LSP, anything)
-- https://github.com/nvim-telescope/telescope.nvim
return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    tag = "v0.1.9",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f<cr>", function()
        builtin.resume()
      end, { desc = "Resume previous search" })
      vim.keymap.set("n", "<C-a>", builtin.live_grep, { desc = "Find using grep" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fc", builtin.buffers, { desc = "Find word under cursor" })
      vim.keymap.set("n", "<leader>fC", builtin.commands, { desc = "Find commands" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fF", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = "Find all files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find using grep" })
      vim.keymap.set("n", "<leader>fG", builtin.git_files, { desc = "Find Git files" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ prompt_title = "Config files", cwd = vim.fn.stdpath("config"), follow = true })
      end, { desc = "Find Neovim config files" })

      vim.keymap.set("n", "<Leader>lD", function()
        require("telescope.builtin").diagnostics()
      end, { desc = "Search diagnostics" })
      vim.keymap.set("n", "<leader>ls", function()
        require("telescope").extensions.aerial.aerial()
      end, { desc = "Search symbols" })
      vim.keymap.set("n", "<leader>lS", function()
        require("aerial").toggle()
      end, { desc = "Symbols outline" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })
    end,
  },
}

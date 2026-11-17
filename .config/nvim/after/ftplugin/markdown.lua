-- Only apply to real files, not scratch markdown buffers like LSP hover popups
if vim.bo.buftype ~= '' then
  return
end

vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.bo.shiftwidth = 4 -- Indentation margin
vim.bo.tabstop = 4
vim.bo.expandtab = true

-- Soft wrap at 79 by centering the window at that width
vim.schedule(function()
  require('no-neck-pain').enable 'markdown'
end)

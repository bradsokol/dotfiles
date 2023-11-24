local M = {}

function M.map(mode, shortcut, command, options)
  local opts = { noremap = true }
  if options then
    opts = vim.tbl_extend('force', opts, options)
  end
  vim.keymap.set(mode, shortcut, command, opts)
end

function M.imap(shortcut, command, options)
  M.map('i', shortcut, command, options)
end

function M.nmap(shortcut, command, options)
  M.map('n', shortcut, command, options)
end

function M.vmap(shortcut, command, options)
  M.map('v', shortcut, command, options)
end

return M

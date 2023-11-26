if not vim.fn.has("macunix") then
  return {}
end

return {
  'rizzatti/dash.vim',
  keys = {
    { '<leader>h', ':Dash<CR>' },
  },
}

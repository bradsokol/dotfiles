if not vim.fn.has("macunix") then
  return {}
end

return {
  'wojciech-kulik/xcodebuild.nvim',
  config = function()
    require('xcodebuild').setup({})
  end,
}

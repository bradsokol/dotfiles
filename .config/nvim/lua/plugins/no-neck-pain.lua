-- Center the focused window at a fixed width
-- https://github.com/shortcuts/no-neck-pain.nvim
return {
  'shortcuts/no-neck-pain.nvim',
  cmd = 'NoNeckPain',
  -- Enabled for markdown from after/ftplugin/markdown.lua
  opts = {
    -- Window width, including the gutter: 79 text + 6 gutter (number + sign) + 2 separators (text is 80 on even-width terminals)
    width = 87,
  },
}

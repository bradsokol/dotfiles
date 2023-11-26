return {
  'github/copilot.vim',
  config = function()
    local g = vim.g

    if vim.fn.has("macunix") == 1 then
      g.copilot_node_command = "/opt/homebrew/opt/node/bin/node"
    else
      if vim.fn.has("linux") == 1 then
        g.copilot_node_command = "/usr/local/bin/node"
      end
    end

    g.copilot_no_tab_map = true
    g.copilot_assume_mapped = true
    g.copilot_tab_fallback = ""
  end
}

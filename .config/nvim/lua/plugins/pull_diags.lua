-- Enable pull diagnostics for neovim LSP < v0.10
return { "catlee/pull_diags.nvim", event = "LspAttach", opts = {} }

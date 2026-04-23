-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- In your snacks config or keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

opts.desc = "Workspace Symbols"
map("n", "fs", function()
  Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter })
end, opts)

opts.desc = "Workspace Class and Interface symbols"
map("n", "fS", function()
  Snacks.picker.lsp_workspace_symbols({
    filter = { default = { "Class", "Interface" } },
  })
end, opts)

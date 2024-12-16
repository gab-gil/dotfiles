return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        angularls = function(_, opts)
          local util = require("lspconfig.util")
          opts.root_dir = util.root_pattern("angular.json", "project.json")
        end,
      },
    },
  },
}

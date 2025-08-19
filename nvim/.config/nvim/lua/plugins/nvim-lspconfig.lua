return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("nx.json", "workspace.json", "project.json", "angular.json")(fname)
          end,
        },
      },
    },
  },
}

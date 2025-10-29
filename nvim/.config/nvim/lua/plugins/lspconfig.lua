return {
  {
    "neovim/nvim-lspconfig",
    --- @type vim.lsp.Config
    opts = {
      servers = {
        jdtls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "gradle.properties")(fname)
          end,
        },
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

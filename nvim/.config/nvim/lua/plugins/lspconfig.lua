return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "gradle.properties")(fname)
          end,
        },
      },
    },
  },
}

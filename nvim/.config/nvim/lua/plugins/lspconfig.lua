return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.filetype.add({
        filename = {
          ["Tiltfile"] = "tiltfile",
        },
      })

      vim.treesitter.language.register("python", "tiltfile")

      local configs = require("lspconfig.configs")
      if not configs.tilt then
        configs.tilt = {
          default_config = {
            cmd = { "tilt", "lsp", "start" },
            filetypes = { "tiltfile" },
            root_dir = require("lspconfig.util").root_pattern("Tiltfile", ".git"),
            single_file_support = true,
          },
        }
      end

      opts.servers = opts.servers or {}
      opts.servers.tilt = {}
      opts.servers.jdtls = {
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "gradle.properties")(fname)
        end,
      }
      opts.servers.angularls = {
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("nx.json", "workspace.json", "project.json", "angular.json")(fname)
        end,
      }
      opts.servers.pyright = {
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", ".git")(fname)
        end,
        settings = {
          python = {
            venvPath = ".",
            venv = ".venv",
            reportMissingImports = true,
            reportMissingTypeStubs = false,
            pythonPath = ".venv/bin/python",
          },
        },
      }

      return opts
    end,
  },
}

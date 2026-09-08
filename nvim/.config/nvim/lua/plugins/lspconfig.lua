return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.angularls = {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(fname, { "nx.json", "workspace.json", "project.json", "angular.json" })
          if root then
            on_dir(root)
          end
        end,
      }
      opts.servers.pyright = {
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

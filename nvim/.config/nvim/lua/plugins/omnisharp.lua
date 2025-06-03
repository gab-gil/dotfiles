return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          cmd = {
            vim.fn.stdpath("data") .. "/mason/bin/OmniSharp",
            "--languageserver",
            "--hostPID",
            tostring(vim.fn.getpid()),
          },
        },
      },
    },
  },
}

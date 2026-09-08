return {
  {
    "mason-org/mason.nvim",
    --- @module 'mason'
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "roslyn",
        "rzls",
      },
    },
  },
}

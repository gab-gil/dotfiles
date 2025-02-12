return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["t"] = "toggle_node",
        },
      },
      nesting_rules = {
        ["cs"] = { "Request.cs", "Response.cs" },
      },
    },
  },
}

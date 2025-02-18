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
        ["cs"] = {
          pattern = "(.*)%.cs",
          files = { "%1.Request.cs", "%1.Response.cs" },
        },
      },
    },
  },
}

return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        menu = {
          draw = {
            columns = {
              {
                "label",
                "label_description",
              },
              {
                "kind_icon",
                "kind",
              },
            },
          },
        },
      },
    },
  },
}

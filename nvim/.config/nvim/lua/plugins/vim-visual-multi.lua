return {
  {
    "mg979/vim-visual-multi",
    lazy = false, -- don't lazy-load
    init = function()
      vim.g.VM_show_warnings = 0
      vim.g.VM_silent_exit = 1
      vim.g.VM_maps = {
        ["Goto Next"] = "]v",
        ["Goto Prev"] = "[v",
        ["I CtrlB"] = "<M-b>",
        ["I CtrlF"] = "<M-f>",
        ["I Return"] = "<S-CR>",
        ["I Down Arrow"] = "",
        ["I Up Arrow"] = "",
      }
    end,
  },
}

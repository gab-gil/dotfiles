local M = {}

function M.generate_component(skipTests)
  local inputs = require("neo-tree.ui.inputs")
  inputs.input("Component's name", "", function(input)
    local state = require("neo-tree.sources.manager").get_state("filesystem")

    local node = state.tree:get_node()
    if node and node.path then
      if node.type == "directory" then
        vim.cmd(("cd " .. node.path))
        local cmd = { "ng", "g", "c", "--defaults", "--standalone" }
        if skipTests then
          table.insert(cmd, "--skip-tests")
        end
        table.insert(cmd, input)
        vim.fn.system(cmd)
      end
    end
  end)
end

function M.generate_service(skipTests)
  local inputs = require("neo-tree.ui.inputs")
  inputs.input("Services's name", "", function(input)
    local state = require("neo-tree.sources.manager").get_state("filesystem")

    local node = state.tree:get_node()
    if node and node.path then
      if node.type == "directory" then
        vim.cmd(("cd " .. node.path))
        local cmd = { "ng", "g", "s", "--defaults" }
        if skipTests then
          table.insert(cmd, "--skip-tests")
        end
        table.insert(cmd, input)
        vim.fn.system(cmd)
      end
    end
  end)
end

local wk = require("which-key")

wk.add({
  "<leader>Agc",
  function()
    M.generate_component(false)
  end,
  desc = "Generate Standalone Component",
})

wk.add({
  "<leader>AgC",
  function()
    M.generate_component(true)
  end,
  desc = "Generate Standalone Component (Skip Tests)",
})

wk.add({
  "<leader>Ags",
  function()
    M.generate_service(false)
  end,
  desc = "Generate Service",
})

wk.add({
  "<leader>AgS",
  function()
    M.generate_service(true)
  end,
  desc = "Generate Service (Skip Tests)",
})

return M

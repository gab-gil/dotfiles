local M = {}

function M.generate_component(skipTests)
  local inputs = require("neo-tree.ui.inputs")
  inputs.input("Component's name", "", function(input)
    local state = require("neo-tree.sources.manager").get_state("filesystem")

    local node = state.tree:get_node()
    if node and node.path then
      if node.type == "directory" then
        vim.cmd(("cd " .. node.path))
        local cmd = { "ng", "g", "c", "--defaults" }
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

function M.rename_component()
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  local node = state.tree:get_node()

  if node and node.path and node.type == "directory" then
    for _, child in ipairs(state.tree:get_nodes(node:get_id())) do
      local index = string.find(child.name, ".component.ts")
      if index == nil then
        goto continue
      end
      local component_name = string.sub(child.name, 1, index - 1)
      local inputs = require("neo-tree.ui.inputs")
      inputs.input("Rename component", component_name, function(input)
        print(input)
        for _, child in ipairs(state.tree:get_nodes(node:get_id())) do
          local hit = string.find(child.name, (component_name .. ".component."))
          if hit ~= nil then
            -- TODO: Rename all file starting with the string you grabed with the new input
          end
          -- TODO: Rename selector symbol in component.ts
          -- TODO: Rename class name symbol  in component.ts
        end
      end)
      ::continue::
    end
  end
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

wk.add({
  "<leader>Acr",
  M.rename_component,
  desc = "Rename Component",
})

return M

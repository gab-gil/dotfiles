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
      local index = string.find(child.name, "%.component%.ts$")
      if index == nil then
        goto continue
      end
      local dashed_old_component = string.sub(child.name, 1, index - 1)
      local inputs = require("neo-tree.ui.inputs")
      local uv = vim.uv
      local utils = require("neo-tree.utils")
      local clients = vim.lsp.get_clients()

      local pascal_old_component = (dashed_old_component:gsub("-(%w)", function(c)
        return c:upper()
      end)):gsub("^(.)", function(c)
        return c:upper()
      end)

      inputs.input("Rename component", pascal_old_component, function(input)
        print("PROBLEM")
        input = input:gsub("^%l", string.upper)
        local dashed_component_name = input:gsub("(%l)(%u)", "%1-%2"):lower()

        local parent_folder_path, _ = utils.split_path(node.path)
        local old_folder_path = node.path
        local new_folder_path = parent_folder_path .. utils.path_separator .. dashed_component_name

        for _, sub_node in ipairs(state.tree:get_nodes(node:get_id())) do
          local hit = string.find(sub_node.name, (dashed_old_component .. ".component."))
          if hit ~= nil then
            local parent_path, _ = utils.split_path(sub_node.path)
            local _, extension = sub_node.name:match("^(.-)(%..+)$")
            local newUri = parent_path .. utils.path_separator .. dashed_component_name .. extension

            local oldUri = sub_node.path

            uv.fs_rename(oldUri, newUri, function(err)
              -- INFO: Notify LSP
              -- clients is an array of Client[]. This means that ipairs will return the index as the key and client as the value
              for _, client in ipairs(clients) do
                client.notify("workspace/didRenameFiles", {
                  files = {
                    {
                      oldUri = oldUri,
                      newUri = newUri,
                    },
                  },
                })
              end

              local ts_hit = string.find(newUri, "%.component%.ts$")
              if ts_hit ~= nil then
                vim.schedule(function()
                  utils.open_file(state, newUri, "e")

                  local bufnr = utils.find_buffer_by_name(newUri)

                  local lnum, col = unpack(vim.fn.searchpos([[@Component\(.\|\n\)\+export class \zs\(\w\+\)\ze]], "n"))

                  vim.api.nvim_set_current_buf(bufnr)

                  -- TODO: Grab the selector value before the modification for a global search and replace using ripgrep + sed

                  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                  local content = table.concat(lines)

                  local regex = "selector.-['|\"](.-)['|\"]"
                  local selector = content:match(regex)

                  local root_dir

                  -- Loop through clients to find angularls
                  for _, client in ipairs(clients) do
                    if client.name == "angularls" then
                      root_dir = client.config.root_dir
                    end
                  end

                  vim.bo.ma = true

                  vim.api.nvim_command(
                    [[:%s/selector.\+\zs]] .. dashed_old_component .. [[\ze/]] .. dashed_component_name
                  )
                  vim.api.nvim_command(
                    [[:%s/templateUrl[^']\+'\zs.\+\ze'/.\/]] .. dashed_component_name .. ".component.html"
                  )
                  vim.api.nvim_command(
                    [[:%s/styleUrl[^']\+'\zs.\+\ze'/.\/]] .. dashed_component_name .. ".component.less"
                  )

                  vim.fn.system(
                    "cd "
                      .. root_dir
                      .. "&& rg '"
                      .. selector
                      .. "' -l | xargs sed -i 's/<"
                      .. selector
                      .. ">/<"
                      .. dashed_component_name
                      .. ">/g'"
                  )

                  vim.fn.system(
                    "cd "
                      .. root_dir
                      .. "&& rg '"
                      .. selector
                      .. "' -l | xargs sed -i 's/<\\/"
                      .. selector
                      .. ">/<\\/"
                      .. dashed_component_name
                      .. ">/g'"
                  )

                  vim.api.nvim_command("w!")

                  -- -- INFO: Notify LSP
                  local file_uri = vim.uri_from_fname(newUri)
                  for _, client in ipairs(clients) do
                    if client.name == "vtsls" then
                      client.request("textDocument/rename", {
                        newName = input .. "Component",
                        textDocument = {
                          uri = file_uri,
                        },
                        position = {
                          line = lnum - 1,
                          character = col - 1,
                        },
                      }, function(err, result, context, config)
                        if err ~= nil then
                          print(err)
                        elseif result ~= nil then
                          for uri, text_edits in pairs(result.changes) do
                            local fname = vim.uri_to_fname(uri)
                            local buf = vim.fn.bufadd(fname)

                            vim.fn.bufload(buf)

                            for _, edit in pairs(text_edits) do
                              vim.api.nvim_buf_set_text(
                                buf,
                                edit.range.start.line,
                                edit.range.start.character,
                                edit.range["end"].line,
                                edit.range["end"].character,
                                { edit.newText }
                              )
                            end
                          end
                        end
                      end)
                    end
                  end
                end)
              end
            end)
          end
        end
        print("OLD: " .. old_folder_path)
        print("NEW: " .. new_folder_path)
        -- vim.schedule(function()
        --   -- TODO: Do the folder renaming at the end
        --   uv.fs_rename(node.path, new_folder_path, function()
        --     for _, client in ipairs(clients) do
        --       client.notify("workspace/didRenameFiles", {
        --         files = {
        --           {
        --             oldUri = vim.uri_from_fname(node.path),
        --             newUri = vim.uri_from_fname(new_folder_path),
        --           },
        --         },
        --       })
        --     end
        --   end)
        -- end)
      end)
      ::continue::
    end
  end
end

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
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

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = dap.configurations.cs or {}

      table.insert(dap.configurations.cs, {
        type = "coreclr",
        name = "Launch - Development",
        request = "launch",
        program = function()
          return coroutine.create(function(coro)
            local dll_files = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/**/*.dll", true, true)
            local file_map = {}
            for _, path in ipairs(dll_files) do
              local filename = vim.fn.fnamemodify(path, ":t")
              file_map[filename] = path
            end

            local files = vim.tbl_keys(file_map)
            local choice = vim.ui.select(files, { prompt = "Select:" }, function(choice)
              print(file_map[choice])
              coroutine.resume(coro, file_map[choice])
            end)
          end)
        end,
        env = {
          ASPNETCORE_ENVIRONMENT = "Development",
        },
      })

      table.insert(dap.configurations.cs, {
        type = "coreclr",
        name = "Launch - Local",
        request = "launch",
        program = function()
          return coroutine.create(function(coro)
            local dll_files = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/**/*.dll", true, true)
            local file_map = {}
            for _, path in ipairs(dll_files) do
              local filename = vim.fn.fnamemodify(path, ":t")
              file_map[filename] = path
            end

            local files = vim.tbl_keys(file_map)
            vim.ui.select(files, { prompt = "Select:" }, function(choice)
              print(file_map[choice])
              coroutine.resume(coro, file_map[choice])
            end)
          end)
        end,
        env = {
          ASPNETCORE_ENVIRONMENT = "Local",
        },
      })
    end,
  },
}

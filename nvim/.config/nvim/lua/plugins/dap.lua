return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#993939", bg = "NONE" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "NONE" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "NONE" })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
      )

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

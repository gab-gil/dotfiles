-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- In your snacks config or keymaps

vim.keymap.set("n", "<leader>rc", function()
  local items = vim.fn.systemlist("history")

  local finder_items = {}
  for idx, item in ipairs(items) do
    local text = item
    table.insert(finder_items, {
      formatted = text,
      text = idx .. " " .. text,
      item = item,
      idx = idx,
    })
  end

  return Snacks.picker.pick({
    source = "Command History",
    items = finder_items,
    format = Snacks.picker.format.ui_select(nil, #items),
    title = "Command History",
    layout = {
      preview = false,
      layout = {
        height = math.floor(math.min(vim.o.lines * 0.8 - 10, #items + 2) + 0.5),
      },
    },
    actions = {
      confirm = function(picker, item)
        picker:close()
        vim.schedule(function()
          vim.cmd(":tabnew | setlocal buftype=nofile | r !" .. item.item)
        end)
      end,
    },
    sort = function(a, b)
      return a.idx < b.idx
    end,
  })
end, { desc = "Run command (history)" })

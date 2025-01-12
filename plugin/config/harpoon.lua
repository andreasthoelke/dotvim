
local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

harpoon:setup({
    -- Setting up custom behavior for a list named "cmd"
  cmd = {

    -- When you call list:add() this function is called and the return
    -- value will be put in the list at the end.
    --
    -- which means same behavior for prepend except where in the list the
    -- return value is added
    --
    -- @param possible_value string only passed in when you alter the ui manual
    add = function(possible_value)
      -- get the current line idx
      local idx = vim.fn.line(".")
      print( 'is this?')
      -- read the current line
      local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
      if cmd == nil then
        return nil
      end

      return {
        value = cmd,
        context = {"hi there"}, -- can store any additional data you want
      }
    end,

    --- This function gets invoked with the options being passed in from
    --- list:select(index, <...options...>)
    --- @param list_item {value: any, context: any}
    --- @param list { ... }
    --- @param option any
    select = function(list_item, list, option)
      -- vim.notify("You selected me: " .. list_item.value)
      -- vim.cmd(list_item.value)
    end
  }
})

-- print(vim.inspect(require("harpoon"):list("cmd")))
-- require("harpoon"):list():select(1)
-- require("harpoon"):list("cmd"):select(1)

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<localleader>a", function() harpoon:list("cmd"):add() end)
vim.keymap.set("n", "<leader>bb", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>aab", function() harpoon.ui:toggle_quick_menu(harpoon:list("cmd")) end)

vim.keymap.set("n", ",1", function() harpoon:list():select(1) end)
vim.keymap.set("n", ",2", function() harpoon:list():select(2) end)
vim.keymap.set("n", ",3", function() harpoon:list():select(3) end)
vim.keymap.set("n", ",4", function() harpoon:list():select(4) end)
vim.keymap.set("n", ",5", function() harpoon:list():select(5) end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "]a", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "[a", function() harpoon:list():next() end)
vim.keymap.set("n", "]a", function() harpoon:list("cmd"):prev() end)
vim.keymap.set("n", "[a", function() harpoon:list("cmd"):next() end)


-- Test commands for default list:
-- lua require("harpoon"):list():add()
-- lua print(vim.inspect(require("harpoon"):list()))
-- lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())

-- Test commands for "cmd" list:
-- lua require("harpoon"):list("cmd"):add()  -- Add current line as command
-- lua print(vim.inspect(require("harpoon"):list("cmd")))  -- Inspect cmd list contents
-- lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list("cmd"))  -- Show cmd menu

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "<leader>abb", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })












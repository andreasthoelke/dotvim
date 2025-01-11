
local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

-- REQUIRED
harpoon:setup({
  settings = {
    save_on_toggle = false,
    sync_on_ui_close = false,
    key = function()
      return vim.loop.cwd()
    end
  },
  -- Add UI configuration
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
    auto_close = false,
  }
})

local function show_harpoon_menu()
    print("4. Entering show_harpoon_menu()")
    local list = harpoon:list()
    if not (list and list.items) then
        print("No items in harpoon list")
        return
    end
    
    print("5. List items count:", #list.items)
    
    -- Directly toggle the menu without creating a temporary buffer
    harpoon.ui:toggle_quick_menu(list)
end

vim.keymap.set("n", "<leader>bb", function()
    print("1. Starting keymap function...")
    print("2. Opening harpoon menu...")
    local ok, err = pcall(show_harpoon_menu)
    print("3. After pcall")
    if not ok then
        print("Error:", err)
    end
end)





vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)




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

vim.keymap.set("n", "<leader>abb", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })













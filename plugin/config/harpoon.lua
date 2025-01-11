
local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

-- REQUIRED
harpoon:setup({
    settings = {
        save_on_toggle = false,
        sync_on_ui_close = false
    }
})

-- Helper function to safely create and show menu
local function show_harpoon_menu()
    print("4. Entering show_harpoon_menu()")
    local list = harpoon:list()
    if not (list and list.items) then
        print("No items in harpoon list")
        return
    end
    
    print("5. List items count:", #list.items)
    
    -- Create a buffer with a window to display the menu
    local buf = vim.api.nvim_create_buf(false, true)
    if not buf then
        print("Failed to create buffer")
        return
    end
    print("6. Buffer created:", buf)
    
    -- Set some buffer options
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'harpoon')
    print("7. Buffer options set")
    
    -- Create the menu with a small delay
    vim.defer_fn(function()
        print("8. Inside defer_fn")
        pcall(function()
            print("9. About to toggle menu")
            harpoon.ui:toggle_quick_menu(list)
            print("10. After toggle menu")
        end)
    end, 10)
    print("11. End of show_harpoon_menu()")
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













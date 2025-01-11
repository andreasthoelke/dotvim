
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
    vim.notify("4. Entering show_harpoon_menu()", vim.log.levels.INFO)
    local list = harpoon:list()
    if not (list and list.items) then
        vim.notify("No items in harpoon list", vim.log.levels.WARN)
        return
    end
    
    vim.notify("5. List items count: " .. #list.items, vim.log.levels.INFO)
    
    -- Create a buffer with a window to display the menu
    local buf = vim.api.nvim_create_buf(false, true)
    if not buf then
        vim.notify("Failed to create buffer", vim.log.levels.ERROR)
        return
    end
    vim.notify("6. Buffer created: " .. buf, vim.log.levels.INFO)
    
    -- Set some buffer options
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'harpoon')
    vim.notify("7. Buffer options set", vim.log.levels.INFO)
    
    -- Create the menu with a small delay
    vim.defer_fn(function()
        vim.notify("8. Inside defer_fn", vim.log.levels.INFO)
        pcall(function()
            vim.notify("9. About to toggle menu", vim.log.levels.INFO)
            harpoon.ui:toggle_quick_menu(list)
            vim.notify("10. After toggle menu", vim.log.levels.INFO)
        end)
    end, 10)
    vim.notify("11. End of show_harpoon_menu()", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>bb", function()
    vim.notify("1. Starting keymap function...", vim.log.levels.INFO)
    vim.notify("2. Opening harpoon menu...", vim.log.levels.INFO)
    local ok, err = pcall(show_harpoon_menu)
    vim.notify("3. After pcall", vim.log.levels.INFO)
    if not ok then
        vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
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













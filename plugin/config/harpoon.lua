
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
    local list = harpoon:list()
    if not (list and list.items) then
        print("No items in harpoon list")
        return
    end
    
    print("List items count:", #list.items)
    
    -- Create a buffer with a window to display the menu
    local buf = vim.api.nvim_create_buf(false, true)
    if not buf then
        print("Failed to create buffer")
        return
    end
    
    -- Set some buffer options
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'harpoon')
    
    -- Create the menu with a small delay
    vim.defer_fn(function()
        pcall(function()
            harpoon.ui:toggle_quick_menu(list)
        end)
    end, 10)
end

vim.keymap.set("n", "<leader>bb", function()
    print("Opening harpoon menu...")
    local ok, err = pcall(show_harpoon_menu)
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













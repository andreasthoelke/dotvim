
local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

harpoon:setup()

vim.keymap.set("n", "<leader>cah", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>caf", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)
vim.keymap.set("n", "<leader>oh", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)

vim.keymap.set("n", ",1", function() harpoon:list():select(1) end)
vim.keymap.set("n", ",2", function() harpoon:list():select(2) end)
vim.keymap.set("n", ",3", function() harpoon:list():select(3) end)
vim.keymap.set("n", ",4", function() harpoon:list():select(4) end)
vim.keymap.set("n", ",5", function() harpoon:list():select(5) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "]a", function() harpoon:list():prev() end)
vim.keymap.set("n", "[a", function() harpoon:list():next() end)


-- lua require("harpoon"):list():add()
-- lua putt( require("harpoon"):list() )
-- lua require("harpoon").ui:toggle_quick_menu( require("harpoon"):list() )

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local posOpts = Float_dynAnchorWidth()
    local layout_opts = { layout_config = { vertical = posOpts } }

    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local optsHarp = {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        initial_mode = 'normal',
        sorter = conf.generic_sorter({}),
    }
    local opts = vim.tbl_extend( 'keep', optsHarp or {}, layout_opts )


    require("telescope.pickers").new({}, opts):find()
end

vim.keymap.set("n", "gsh", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })














local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2


-- REQUIRED                                                                                          
harpoon:setup({                                                                                      
    settings = {                                                                                     
        save_on_toggle = false,  -- Change back to false since this causes the error                 
        sync_on_ui_close = false -- Change back to false for now                                     
    }                                                                                                
})                                                                                                   
                                                                                                     
vim.keymap.set("n", "<leader>bb", function()                                                         
  print("Opening harpoon menu...")                                                                 
  local ok, err = pcall(function()                                                                 
    local list = harpoon:list()                                                                  
    if list and list.items then                                                                  
      print("List items 2 count:", #list.items)                                                  
      -- Try creating the buffer before showing the menu                                       
      vim.schedule(function()                                                                  
        local buf = vim.api.nvim_create_buf(false, true)                                     
        if buf then                                                                          
          harpoon.ui:toggle_quick_menu(list)                                               
        else                                                                                 
          print("Failed to create buffer")                                                 
        end                                                                                  
      end)                                                                                     
    else                                                                                         
      print("No items in harpoon list")                                                        
    end                                                                                          
  end)                                                                                             
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













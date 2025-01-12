
local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

harpoon:setup()

vim.keymap.set("n", "<leader>cah", function() Hpon_add_current_file_row_col() end)
vim.keymap.set("n", "<leader>caf", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)
vim.keymap.set("n", "<leader>oh", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)

vim.keymap.set("n", ",1", function() harpoon:list():select(1) end)
vim.keymap.set("n", ",2", function() harpoon:list():select(2) end)
vim.keymap.set("n", ",3", function() harpoon:list():select(3) end)
vim.keymap.set("n", ",4", function() harpoon:list():select(4) end)
vim.keymap.set("n", ",5", function() harpoon:list():select(5) end)

vim.keymap.set("n", ",d1", function() harpoon:list():remove_at(1) end)
vim.keymap.set("n", ",d2", function() harpoon:list():remove_at(2) end)
vim.keymap.set("n", ",d3", function() harpoon:list():remove_at(3) end)
vim.keymap.set("n", ",d4", function() harpoon:list():remove_at(4) end)
vim.keymap.set("n", ",d5", function() harpoon:list():remove_at(5) end)

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

function _G.Hpon_add_current_file_row_col()
  local file_path = vim.fn.expand('%:p')  -- Get full path of current buffer
  local cursor = vim.api.nvim_win_get_cursor(0)  -- Get cursor position [row, col]
  Hpon_add_file(file_path, {row = cursor[1], col = cursor[2]})
end

---@param file_path string Path to file to add                            
---@param opts? {row?: number, col?: number} Optional cursor position     
function _G.Hpon_add_file(file_path, opts)                                      
  opts = opts or {}                                                     
  local list_item = {                                                   
    value = file_path,                                                
    context = {                                                       
      row = opts.row or 1,                                          
      col = opts.col or 0                                           
    }                                                                 
  }                                                                     
  require("harpoon"):list():add(list_item)                              
  vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI
end                                                                       
                                                                          
-- Hpon_add_file("path/to/file.txt")                       
-- Hpon_add_file("path/to/bb.txt", {row = 10, col = 5})  


---@return table List of all items in harpoon                             
function _G.Hpon_get_list()                                                     
  local list = require("harpoon"):list()                                
  local items = {}                                                      
  for idx = 1, list:length() do                                         
    local item = list:get(idx)                                        
    if item then                                                      
      table.insert(items, {                                         
        index = idx,                                              
        value = item.value,                                       
        context = item.context                                    
      })                                                            
    end                                                               
  end                                                                   
  return items                                                          
end                                                                       
-- Hpon_get_list()


---Print the current harpoon list to console                              
function _G.Hpon_print_list()                                                   
  local items = Hpon_get_list()
  if #items == 0 then                                                   
    print("Harpoon list is empty")                                    
    return                                                            
  end                                                                   
  print("Harpoon list:")                                                
  for _, item in ipairs(items) do                                       
    print(string.format("%d: %s (row:%d, col:%d)",                    
      item.index,                                                   
      item.value,                                                   
      item.context.row,                                             
      item.context.col))                                            
  end                                                                   
end                                                                       
-- Hpon_print_list()


---Remove an item at the specified index from the harpoon list            
---@param index number The index to remove                                
function _G.Hpon_remove_at(index)                                         
  require("harpoon"):list():remove_at(index)                            
  vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI
  -- print(string.format("Removed item at index %d", index))               
end                                                                       
-- Hpon_remove_at(1)

---Remove an item by its file path from the harpoon list                  
---@param file_path string The file path to remove                        
function _G.Hpon_remove(file_path)                                        
  local list = require("harpoon"):list()                                
  local item = {                                                        
    value = file_path,                                                
    context = {                                                       
      row = 1,                                                      
      col = 0                                                       
    }                                                                 
  }                                                                     
  list:remove(item)                                                     
  vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI
  -- print(string.format("Removed '%s' from list", file_path))             
end                                                                       
-- Hpon_remove("path/to/file.txt")



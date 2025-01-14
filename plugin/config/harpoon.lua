
-- Note: the plugin is updated: ~/.config/nvim/plugged/harpoon/README.md
-- see the commits. persistence is working in 
-- ~/.local/share/nvim/harpoon/
-- initial row, column is saved. but harpoon/vim maintains the current cursor, but is not updating the json.
-- Issue: telescope doesn't maintain/use the current buffer pos. could have aider fix this.
-- Note: i can just edit the edit the harpoon menu/buffer (like using ]e to change sequ) and then ,,w. still needs a vim window change to update the neotree view
-- Note: these maps work in the harpoon buffer and in telescope: ~/.config/nvim/plugin/utils/NewBuf-direction-maps.vim‖*NewBufˍfromˍpath
-- abs and cwd relative paths are supported!

-- TODO: bring back ui update vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI

local harpoon = require("harpoon")
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    save_on_change = true
  }
})

vim.keymap.set("n", "<leader>ah", function() Hpon_add_file_linkPath() end)
vim.keymap.set("n", "<leader>aa", function() Hpon_add_file_linkPath() end)
vim.keymap.set("n", "<leader>ad", function() Hpon_remove_current_file() end)

vim.keymap.set("n", "<leader>af", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)
vim.keymap.set("n", "<leader>oh", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" }) end)

vim.keymap.set("n", ",1", function() harpoon:list():select(1) end)
vim.keymap.set("n", ",2", function() harpoon:list():select(2) end)
vim.keymap.set("n", ",3", function() harpoon:list():select(3) end)
vim.keymap.set("n", ",4", function() harpoon:list():select(4) end)
vim.keymap.set("n", ",5", function() harpoon:list():select(5) end)

vim.keymap.set("n", ",d1", function() Hpon_remove_at(1) end)
vim.keymap.set("n", ",d2", function() Hpon_remove_at(2) end)
vim.keymap.set("n", ",d3", function() Hpon_remove_at(3) end)
vim.keymap.set("n", ",d4", function() Hpon_remove_at(4) end)
vim.keymap.set("n", ",d5", function() Hpon_remove_at(5) end)

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

function _G.Hpon_remove_current_file()                                         
  local file_path = vim.fn.expand('%:p')  -- Get full path of current buffer
  Hpon_remove(file_path)                            
end                                                                       
-- Hpon_remove_current_file()


---@param file_path string Path to file to add                            
---@param links table
function _G.Hpon_update_file_item(file_path, links)                                      
  opts = opts or {}                                                     
  local list_item = {                                                   
    value = file_path,                                                
    context = { links = links }
  }                                                                     
  require("harpoon"):list():add(list_item)                              
end                                                                       
-- Hpon_add_file("path/to/file.txt")                       
-- Hpon_add_file("path/to/bb.txt", {row = 10, col = 5})  
-- Hpon_add_file("path/to/bbcb.txt", {"hi there", "c"})  
-- Hpon_get_list()

-- lua putt(vim.fn.LinkPath_as_tuple())

---@param opts? {row?: number, col?: number} Optional cursor position     
function _G.Hpon_add_file_linkPath()                                      
  local file_path, linkExt = vim.fn.LinkPath_as_tuple()
  Hpon_add_file_join_links( file_path, linkExt )
  vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI
end                                                                       

---@param file_path string Path to add                            
---@param link string link to add
function _G.Hpon_add_file_join_links(path, link)                                      
  local items = Hpon_get_list()
  
  if #items == 0 then
    -- If list is empty, just add the new file with the link
    Hpon_update_file_item(path, {link})
    return
  end

  local found = false
  for _, item in ipairs(items) do                                       
    if item.value == path then
      found = true                                                    
      -- Check if link already exists in the array
      local exists = false
      local joined_links = {}
      if item.links then
        for _, existing_link in ipairs(item.links) do
          if existing_link == link then
            exists = true
          end
          table.insert(joined_links, existing_link)
        end
      end
      -- Only add if it's a new unique link
      if not exists then
        table.insert(joined_links, link)
      end
      Hpon_update_file_item(path, joined_links)
    end
  end

  -- If path wasn't found in existing items, add it with the new link
  if not found then
    Hpon_update_file_item(path, {link})
  end
end                                                                       
-- Hpon_get_list()
-- Hpon_add_file_join_links("path/to/bbxb.txt", "new3")  
-- require("harpoon"):list():display()

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
        links = item.context.links
      })                                                            
    end                                                               
  end                                                                   
  return items                                                          
end                                                                       
-- Hpon_get_list()
-- require("harpoon"):list():display()

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



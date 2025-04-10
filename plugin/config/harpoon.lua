
-- ISSUES 2025-04
-- the neo-tree indicators are initialized after close-reopen. then ,d1/2 does update the view.
-- ,d1/2 does delete, but the update of the file only occurs after ,1/2. if right after ,d1 i do l oh, the old state is loaded
-- "line if not unique warning" -> just add the path.
-- neo tree should show indicators
-- neo tree should allow adding just paths
-- clear all map
-- clear from neo tree map

-- Issue: when a file has multiple links, jumping via index doesn't work
-- also in this file jumping to a function link doesn't work, just the file

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
-- NOTE: the logs work! 
-- require("harpoon.logger"):show()
-- DATAFOLDER: containing the JSON
-- del ~/.local/share/nvim/harpoon/
-- -- could use this ]a [a to keep win closed or close other haroon win.
-- vim.g["harpoon_win_id"]
-- vim.g["harpoon_bufnr"]

-- require("harpoon.data"); local filepath = vim.fn.expand("~/.local/share/nvim/harpoon/e0004d269748d1517cd913798536e799acaf561b0b7488a8345648687eb6ab02.json"); local json_data = data.load_harpoon_file(filepath); print(vim.inspect(json_data))

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  }
})

vim.keymap.set("n", "<leader>ah", function() 
  Hpon_add_file_linkPath()
  Hpon_refresh()
end)
vim.keymap.set("n", "<leader>aa", function() Hpon_add_file_linkPath() end)
vim.keymap.set("n", "<leader>ad", function() 
  Hpon_remove_current_file() 
  Hpon_refresh()
end)
vim.keymap.set("n", "<leader>aD", function() Hpon_clearList() end)
vim.keymap.set("n", "<leader>al", function() 
  local data = require("harpoon.data")
  local filepath = vim.fn.expand("~/.local/share/nvim/harpoon/e0004d269748d1517cd913798536e799acaf561b0b7488a8345648687eb6ab02.json")
  local json_data = data:load_harpoon_file(filepath)
  print(vim.inspect(json_data))
  -- require("harpoon"):reload() 
end)

vim.keymap.set("n", "<leader>af", function() 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
end)

vim.keymap.set("n", "<leader>oh", function() 
  Hpon_load( 'ExampleLinks.md' )
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
end)

vim.keymap.set("n", "<leader>oH", function() vim.fn.Path_Float( 'ExampleLinks.md' ) end)
vim.keymap.set("n", "<leader>oE", function() vim.fn.Path_Float( 'ExampleLinks.md' ) end)


-- vim.keymap.set("n", ",1", function() 
--     harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
--     vim.api.nvim_win_set_cursor(0, {1, 0})
--     vim.cmd( 'wincmd p' )
-- end)


vim.keymap.set("n", ",1", function() 
  harpoon:list():select(1) 
  Hpon_refresh()
end)
vim.keymap.set("n", ",2", function() 
  harpoon:list():select(2) 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )
end)
vim.keymap.set("n", ",3", function() 
  harpoon:list():select(3) 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )
end)
vim.keymap.set("n", ",4", function() 
  harpoon:list():select(4) 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )
end)
vim.keymap.set("n", ",5", function() 
  harpoon:list():select(5) 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )
end)

-- vim.keymap.set("n", ",2", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", ",3", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", ",4", function() harpoon:list():select(4) end)
-- vim.keymap.set("n", ",5", function() harpoon:list():select(5) end)

vim.keymap.set("n", ",d1", function() Hpon_remove_at(1) end)
vim.keymap.set("n", ",d2", function() Hpon_remove_at(2) end)
vim.keymap.set("n", ",d3", function() Hpon_remove_at(3) end)
vim.keymap.set("n", ",d4", function() Hpon_remove_at(4) end)
vim.keymap.set("n", ",d5", function() Hpon_remove_at(5) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "[a", function() 
  harpoon:list():prev() 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )

  -- Note: -- could use this ]a [a to keep win closed or close other haroon win.
  -- vim.g["harpoon_win_id"]
  -- not working:
  -- harpoon.ui:refresh_highlight(harpoon:list(), { title = "" })
end)
vim.keymap.set("n", "]a", function() 
  harpoon:list():next() 
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })
  vim.cmd( 'wincmd p' )
end)

-- vim.keymap.set("n", "]a", function() harpoon:list():next() end)


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

function _G.Hpon_clearList()                                         
  require("harpoon"):list():recreate({})                            
  print 'List cleared'
end                                                                       
-- Hpon_remove_current_file()

---@param file_path string Path to file to add                            
---@param links table
function _G.Hpon_update_file_item(file_path, links)                                      
  local pos = vim.api.nvim_win_get_cursor(0)
  local list_item = {                                                   
    value = file_path,                                                
    context = { 
      links = links,
      row = pos[1],
      col = pos[2] 
    }
  }                                                                     
  require("harpoon"):list():add(list_item)                              
  vim.defer_fn(function()
    require("harpoon").ui:refresh()
  end, 100) -- 100ms delay
end                                                                       
-- Hpon_add_file("path/to/file.txt")                       
-- Hpon_add_file("path/to/bb.txt", {row = 10, col = 5})  
-- Hpon_add_file("path/to/bbcb.txt", {"hi there", "c"})  
-- Hpon_get_list()

-- lua putt(vim.fn.LinkPath_as_tuple())

function _G.Hpon_add_file_linkPath()                                      
  local result = vim.fn.LinkPath_as_tuple()
  local file_path = result[1]
  local linkExt = result[2]
  
  Hpon_add_file_join_links(file_path, linkExt)
  vim.cmd("doautocmd BufEnter")  -- Trigger buffer event to refresh UI
end                                                                       

---@param file_path string Path to add                            
---@param link string link to add
function _G.Hpon_add_file_join_links(path, link)                                      
  local items = Hpon_get_list()
  
  -- print("Adding link:", link, "to path:", path)
  -- print("Current items:", vim.inspect(items))
  
  if #items == 0 then
    -- print("Empty list, adding first item")
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
      -- print("Found existing item:", vim.inspect(item))
      if item.context and item.context.links then
        -- print("Existing links:", vim.inspect(item.context.links))
        for _, existing_link in ipairs(item.context.links) do
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
      -- print("Final joined links:", vim.inspect(joined_links))
      Hpon_update_file_item(path, joined_links)
    end
  end

  -- If path wasn't found in existing items, add it with the new link
  if not found then
    -- print("Path not found, adding new item")
    Hpon_update_file_item(path, {link})
  end
end                                                                       
-- Hpon_get_list()
-- Hpon_add_file_join_links("path/to/aa.txt", "new3")  
-- require("harpoon"):list():display()
-- require("harpoon"):list():recreate({"eins", "zwei"})

---@return table List of all items in harpoon                             
function _G.Hpon_get_list()                                                     
  local list = require("harpoon"):list()                                
  local items = {}                                                      
  for idx = 1, list:length() do                                         
    local item = list:get(idx)                                        
    if item then                                                      
      table.insert(items, {                                         
        -- index = idx,                                              
        value = item.value,                                       
        context = item.context,
        -- links = item.context and item.context.links
      })                                                            
    end                                                               
  end                                                                   
  return items                                                          
end                                                                       
-- Hpon_get_list()
-- Hpon_get_list()[2].value
-- require("harpoon"):list():display()
-- require("harpoon"):list():get(2).value
-- require("harpoon"):list()._index


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


-- ─   Helpers                                           ■

-- colors/munsell-blue-molokai.vim‖/hi!ˍdefˍlinkˍTelescopePreviewLineˍCursorLine
-- plugin/basics/CodeMarkup.vim‖/TODO

function _G.Hpon_parentFolderName(line)                                        
  -- Split by ‖ and take first part (the file path)
  local path = vim.split(line, "‖")[1]
  -- Get the directory part of the path
  local parent = vim.fn.fnamemodify(path, ":h:t")
  return parent
end

-- Hpon_parentFolderName("/Users/at/Doc/colors/munsell-blue-molokai.vim‖/hi!ˍdefˍlinkˍTelescopePreviewLineˍCursorLine")
-- Hpon_parentFolderName("plugin/basics/CodeMarkup.vim‖/TODO")
-- Hpon_parentFolderName("")

-- local folderPattern = _G.Hpon_parentFolderName(line) .. "\\ze\\/"
-- vim.fn.matchadd('mdNormHiBG', folderPattern, 11, -1)
-- vim.fn.matchadd('mdNormHi', 'CodeMarkup', 11, -1)

function _G.Hpon_highlighFolderName(line)                                        
  -- local folderPattern = _G.Hpon_parentFolderName(line) .. "\\ze\\/"
end



function _G.FileReadLines( file_path )                                        
  local lines = {}
  local file = io.open(file_path, "r")
  if not file then
    vim.notify("Could not open file: " .. file_path, vim.log.levels.ERROR)
    return lines
  end
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end
-- FileReadLines( 'ExampleLinks.md' )



function _G.Hpon_load( filePath )                                        
  local lines = FileReadLines( filePath )
  require("harpoon"):list():recreate( lines )
end
-- Hpon_load( 'ExampleLinks.md' )

-- plugin/config/neo-tree.lua‖/filesystemˍ=ˍ{
-- plugin/config/harpoon.lua‖/functionˍ_G.Hpon_add_curre
-- ~/Documents/Notes/MCP.md‖/#ˍharpoon
-- plugin/config/harpoon.lua‖/TODO:ˍbringˍbackˍuiˍupdate

-- -- This iterates through filenames and adds a line per link extension
-- TODO: an item might just be a link (not a path).
-- require("harpoon"):list():display()

function _G.Hpon_save()                                        
  local path = "ExampleLinks.md"
  local lines = require("harpoon"):list():display()
  -- save lines to path
  local file = io.open(path, "w")
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()
  -- print( "saved!" )
end
-- Hpon_save()
-- ExampleLinks.md

function _G.Hpon_refresh()                                        
  local old_winid = vim.g["harpoon_win_id"]
  harpoon.ui:toggle_quick_menu(harpoon:list(), { title = "" })

  if old_winid then
    vim.defer_fn(function()
      -- TODO: currently errors
      -- vim.api.nvim_win_close(old_winid, true)
    end, 50)
  end

  vim.cmd('wincmd p')
end

function _G.Hpon_filePaths()                                        
  local harpoon_list = require("harpoon"):list()
  local file_paths = {}
  for _, item in ipairs(harpoon_list.items) do
    local value = item.value
    table.insert(file_paths, value)
  end
  return file_paths
end
-- Hpon_filePaths()



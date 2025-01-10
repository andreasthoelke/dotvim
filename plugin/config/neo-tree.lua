
local f = require 'utils.functional'

vim.g.neo_tree_remove_legacy_commands = 1



-- All config default values:
-- /Users/at/.vim/scratch/neo-tree-defaults.sct
-- ~/.config/nvim/plugged/neo-tree.nvim/lua/neo-tree/defaults.lua

local tree_exec = require 'neo-tree.command'.execute
local renderer = require("neo-tree.ui.renderer")
local manager = require 'neo-tree.sources.manager'
local fs = require("neo-tree.sources.filesystem")
local filesystem_commands = require("neo-tree.sources.filesystem.commands")
local common_commands = require("neo-tree.sources.common.commands")
-- local Preview = require("neo-tree.sources.common.preview")

-- lua putt( require('neo-tree.sources.manager').get_state_for_window() )
-- lua putt( require('neo-tree.sources.manager').get_state_for_window().position )


-- ─   Helpers                                           ■


function _G.Ntree_getOpenFolders()                                                                   
  local winIds = Ntree_winIds(vim.api.nvim_get_current_tabpage())                                    
  if #winIds == 0 then return {} end                                                                 
                                                                                                     
  -- Get state from first neo-tree window                                                            
  local state = manager.get_state_for_window(winIds[1])                                              
  if not state then return {} end                                                                    
                                                                                                     
  -- Get expanded nodes from renderer and make paths relative to cwd
  local cwd = vim.fn.getcwd()
  return vim.tbl_map(function(path)
    return vim.fn.fnamemodify(path, ':.' .. (cwd:sub(-1) == '/' and '' or '/'))
  end, renderer.get_expanded_nodes(state.tree))
end                                                                                                  

-- vim.keymap.set( 'n', '<leader>fu', function() putt(Ntree_getOpenFolders()) end )


-- Note the statusline helper functions here: ~/.config/nvim/plugin/tools-tab-status-lines.vim‖/Ntree_rootDirRel()


function _G.Ntree_find_directory()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function open_ntree(prompt_bufnr, _)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local path = selection.cwd .. "/" .. selection.value
      path = path:sub(1, #path - 1)
      path = vim.fn.fnamemodify( path, ":p" )
      Ntree_revealFile( path )
    end)
    return true
  end

  require("telescope.builtin").find_files({
    prompt_title = "Find Directory",
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_ntree,
  })
end

vim.keymap.set( 'n', '<leader>fd', Ntree_find_directory )

function _G.Ntree_close( state, winid )
  winid = winid or vim.api.nvim_get_current_win()
  state = state ~= nil and state or manager.get_state_for_window( winid )
  common_commands.close_window( state )
  local bufnr = vim.api.nvim_win_get_buf( winid )
  -- close nvim window by id
  vim.api.nvim_win_close( winid, true )
  -- -- dispose the buffer:
  -- vim.api.nvim_buf_delete( bufnr, { force = true } )
  -- -- unlist the buffer:
  -- -- ISSUE: when I open an additional split buffer after opening ntree, then closing ntree, the next line closes other buffers.
  -- vim.api.nvim_command( "bdelete " .. bufnr )
  local tabid = vim.api.nvim_get_current_tabpage()
  if winid == Ntree_leftOpen[tabid] then Ntree_leftOpen[tabid] = nil end
  if winid == Ntree_rightOpen[tabid] then Ntree_rightOpen[tabid] = nil end
end

-- lua Ntree_close( nil, 1016 )
-- lua print( vim.api.nvim_get_current_win() )

function _G.Ntree_cmdInOriginWin( cmd )
  local winid = vim.g['Ntree_prevWinid']
  vim.api.nvim_set_current_win( winid )
  vim.cmd( cmd )
end

function _G.Ntree_winIds( tabid )
  return vim.iter( vim.api.nvim_tabpage_list_wins( tabid ) )
    :map( function(winid)
      return { wid = winid, bid = vim.api.nvim_win_get_buf( winid ) }
    end)
    :filter( function(win)
      local filetype = vim.api.nvim_buf_get_option( win.bid, 'filetype' )
      return filetype == 'neo-tree'
    end)
    :map( function(win) return win.wid end )
    :totable()
end

-- Ntree_winIds( vim.api.nvim_get_current_tabpage() )
-- vim.fn.win_getid()
-- vim.fn.winnr()
-- vim.fn.win_id2tabwin( 1008 )

-- { { "", "tree2", "" }, { "tree1", "" }, { "" } }
-- { { {}, {}, { 1045 }, {}, {} }, { { 1023 }, {}, {} }, { {} } }
-- vim.api.nvim_list_tabpages()


function _G.Ntree_currentNode( state )
  state = state ~= nil and state or manager.get_state_for_window()
  return {
    rootpath = state.path,
    linepath = state.position.node_id
  }
end
-- lua putt( Ntree_currentNode() )

function _G.Ntree_getPathWhenOpen()
  local winIds = Ntree_winIds( vim.api.nvim_get_current_tabpage() )
  if #winIds == 0 then return end
  local winId = winIds[1]
  local state = manager.get_state_for_window( winId )
  if state == nil then return end
  return {
    rootpath = state.path,
    linepath = state.position.node_id
  }
end
-- lua putt( Ntree_getPathWhenOpen() )


function _G.TreeRoot_infoStr( rootPath )
  local lpath = vim.split( rootPath, [[/]] )
  local dir = lpath[ #lpath ]
  local parentDir = lpath[ #lpath -1 ]
  return dir, parentDir
end



-- vim.fn.RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj" )
-- _ ■
-- lua put( Ntree_current() )
-- vim.api.nvim_buf_get_var( 44, "neo_tree_source" )
-- vim.api.nvim_buf_get_var( 44, "neo_tree_winid" )
-- vim.api.nvim_buf_get_var( 1537, "neo_tree_winid" )
-- vim.api.nvim_buf_get_var( 44, "neo_tree_position" )
-- vim.fn.winnr()
-- vim.fn.bufnr()
-- require("neo-tree.sources.manager").get_state_for_window( 1012 ).position
-- Ntree_current(2507)
-- Ntree_current(1012)
-- nil and "yes" or "no"
-- 0 and "yes" or "no"
-- _ ▲ ▲


-- to delete
-- function _G.Ntree_switchToDirvish()
--   local state = manager.get_state_for_window()
--   local folder = vim.fn.fnamemodify( path, ":h" )
--   vim.cmd( "edit " .. folder )
--   vim.fn.SearchLine( path )
--   tree_exec({ action = "close" })
-- end


local utils = require("neo-tree.utils")
-- local parentPath, fname = utils.split_path( reveal_path )

function _G.Util_is_subpath( parentPath, maybeChildPath )
  return utils.is_subpath(parentPath, maybeChildPath)
end

-- Opens a new tree.
function _G.Ntree_launch( focus_path, root_path )
  if (not utils.is_subpath(root_path, focus_path)) or (vim.fn.filereadable(focus_path) == 0) then
    tree_exec({
      position = "current",
      dir = root_path,
    })
  else
    tree_exec({
      position = "current",
      dir = root_path,
      reveal_file = focus_path,
      reveal_force_cwd = true,
    })
  end
end

-- Ntree_launch( "/Users/at/Documents/Proj/g_ts_gql/f_ts_scala/scratch/.testServer.ts", vim.fn.getcwd(-1)  )
-- vim.fn.filereadable( "/Users/at/Documents/Proj/g_ts_gql/f_ts_scala/scratch/.testServer.ts" )


-- to delete ■
-- function _G.Ntree_launch_withAltView( focus_path, root_path )
--   if vim.fn.exists( 'w:AlternateTreeView' ) == 1 then
--     local newViewFields = { focus_path = focus_path, root_path = root_path }
--     local prevTreeView = Ntree_open_setView( vim.w['AlternateTreeView'] )
--     -- Ntree_open_setView( f.merge( newViewFields, prevTreeView ) )
--     Ntree_open_setView( vim.tbl_extend( 'keep', newViewFields, prevTreeView ) )
--   else
--     Ntree_launch( focus_path, root_path )
--   end
-- end ▲


local function open_all_subnodes(state)
  local node = state.tree:get_node()
  filesystem_commands.expand_all_nodes(state, node)
end


-- local fs = require "neo-tree.sources.filesystem"
-- local node = state.tree:get_node()
-- fs.toggle_directory(state, node, nil, false, true)

function _G.Ntree_view_get( state )
  return {
    focus_path     = state.tree:get_node().path,
    expanded_paths = renderer.get_expanded_nodes( state.tree ),
    root_path      = state.path,
    filter_visible = state.filtered_items.visible,
  }
end

function _G.Ntree_view_set( view, state )
  state = state ~= nil and state or manager.get_state('filesystem')
  state.force_open_folders = view.expanded_paths
  state.filtered_items.visible = view.filter_visible
end

-- lua Ntree_view_set( { expanded_paths = { "/Users/at/.config/nvim", "/Users/at/.config/nvim/plugin", "/Users/at/.config/nvim/plugin/utils" }, filter_visible = true, } )
-- lua Ntree_view_set( { "/Users/at/.config/nvim", "/Users/at/.config/nvim/notes", "/Users/at/.config/nvim/notes/minor", "/Users/at/.config/nvim/notes/templates" } )

-- Ntree_launch_setView( {
--   expanded_paths = { "/Users/at/.config/nvim/plugin", "/Users/at/.config/nvim/plugin/config", "/Users/at/.config/nvim/plugin/utils" },
--   filter_visible = true,
--   focus_path = "/Users/at/.config/nvim/plugin/utils",
--   root_path = "/Users/at/.config/nvim/plugin"
-- } )

function _G.Ntree_launch_setView( view )
  Ntree_launch( view.focus_path, view.root_path )
  Ntree_view_set( view )
end

function _G.Ntree_launch_inWin( state, view, winId )
  fs._navigate_internal(state, view.root_path, view.focus_path, nil, false)
  -- set the filetype to neo-tree
  vim.api.nvim_buf_set_option(state.bufnr, "filetype", "neo-tree")
  -- sloppy way to recreate winfixedwidth only on ~/.config/nvim/plugin/config/neo-tree.lua‖/functionˍ_G.Ntree_openLeft
  if vim.api.nvim_win_get_width( winId ) == 29 then
    -- set winfixwidth
    vim.api.nvim_win_set_option(winId, "winfixwidth", true)
  end
end


function _G.Ntree_revealFile( filePath )
  filePath = filePath ~= nil and filePath or vim.fn.expand( "%:p" )
  local winIds = Ntree_winIds( vim.api.nvim_get_current_tabpage() )
  if #winIds == 0 then return end
  -- note we are just using the first win here, could e.g. also use the closest
  local winId = winIds[1]
  local state = manager.get_state_for_window( winId )
  local treeView = Ntree_view_get( state )
  treeView.focus_path = filePath
  Ntree_launch_inWin( state, treeView, winId )
end

vim.keymap.set( 'n', '<leader>gs', Ntree_revealFile )

-- Ntree_revealFile("/Users/at/.config/nvim/notes/minor/some.txt")
-- Ntree_revealFile("/Users/at/.config/nvim/notes/minor/some")

-- Perform the normal node "open" action which might expand a directory in the tree
-- or launch a file buffer in the same window.
-- Additianally saves the treeView to allow gq to return to the same tree-view.
-- Note that saving the treeView on directory expansions does nothing useful. (or could the windowVar/treeView
-- be used after other open commands like "v", "s"?
function _G.Ntree_expandFile_saveView( state )
  local treeView = Ntree_view_get( state )
  filesystem_commands.open( state )
  vim.w['AlternateTreeView'] = treeView
end

-- Save tree-view, restore alt file view.
function _G.Ntree_close_saveView_restoreAltFileLoc( state )
  local treeView = Ntree_view_get( state )
  vim.fn.AlternateFileLoc_restore( 'edit' )
  renderer.close( state, false )
  vim.w['AlternateTreeView'] = treeView
end
-- lua putt( vim.w['AlternateTreeView'] )


function _G.Ntree_close_saveView_showFolderInDirvish( state )
  local treeView = Ntree_view_get( state )
  local path = state.tree:get_node().path
  local folder = vim.fn.fnamemodify( path, ":h" )
  -- putt( folder )
  vim.cmd( "edit " .. folder )
  vim.fn.SearchLine( path )
  vim.w['AlternateTreeView'] = treeView
  renderer.close( state, false )
end


-- Save alt file view, restore alt tree view
function _G.Ntree_launchToAltView_saveAltFileLoc()
  -- captures the file-cursor loc the tree was spawned off of ->
  local captureAltFileLoc = vim.fn.LinkPath_linepos()
  if vim.fn.exists( 'w:AlternateTreeView' ) == 1 then
    Ntree_launch_setView( vim.w['AlternateTreeView'] )
  else
    vim.fn.Browse_parent( 'full' )
  end
  -- .. -> and sets it to a var local to the *new* window!
  vim.w['AlternateFileLoc'] = captureAltFileLoc
end

-- lua Ntree_launchToAltView_saveAltFileLoc()
-- vim.fn.exists( "w:AlternateTreeView" )
-- vim.fn.exists( "w:AlternateTreeView" ) and 't' or 'f'
-- vim.w['AlternateTreeView']

vim.keymap.set( 'n', 'gq', Ntree_launchToAltView_saveAltFileLoc )
-- only set in dirvish maps for now ~/.config/nvim/ftplugin/dirvish.vim‖:47:1
-- vim.keymap.set( 'n', '<c-space>', Ntree_launchToAltView_saveAltFileLoc )
vim.keymap.set( 'n', '<localleader>dt', Ntree_launchToAltView_saveAltFileLoc )


-- vim.keymap.set( 'n', '<leader>Os', Ntree_launchToAltView_saveAltFileLoc )



_G.Ntree_leftOpen = {}
-- Ntree_leftOpen
function _G.Ntree_leftOpen_getPersist() return Util_TabWinId_to_Indexes( Ntree_leftOpen ) end
function _G.Ntree_leftOpen_restore( listIndexes ) _G.Ntree_leftOpen = Util_Indexes_to_TabWinId(  listIndexes ) end
_G.Ntree_rightOpen = {}
-- Ntree_rightOpen
function _G.Ntree_rightOpen_getPersist() return Util_TabWinId_to_Indexes( Ntree_rightOpen ) end
function _G.Ntree_rightOpen_restore( listIndexes ) _G.Ntree_rightOpen = Util_Indexes_to_TabWinId(  listIndexes ) end

function _G.Util_TabWinId_to_Indexes( idTable )
  local tabIds = vim.tbl_keys( idTable )

  local withTabNums = vim.tbl_map( function( tabId )
    local tabIndex = vim.fn.index( vim.api.nvim_list_tabpages(), tabId ) + 1
    return { tabIndex, tabId, idTable[ tabId ] }
  end, tabIds )

  local withWinNums = vim.tbl_map( function( tab )
    local tabIndex, tabId, winId = table.unpack( tab )
    local tabnr, winnr = table.unpack( vim.fn.win_id2tabwin( winId ) )
    return {tabnr, winnr}
  end, withTabNums )

  return withWinNums
end

-- Util_TabWinId_to_Indexes( Ntree_rightOpen )
-- Ntree_rightOpen

function _G.Util_Indexes_to_TabWinId( listIndexes )
  local idTable = {}
  for _, tabWin in ipairs( listIndexes ) do
    local tabnr, winnr = table.unpack( tabWin )
    local winId = vim.fn.win_getid( winnr, tabnr )
    idTable[ tabnr ] = winId
  end
  return idTable
end
-- Ntree_rightOpen_persist()
-- Util_Indexes_to_TabWinId( Ntree_rightOpen_persist() )

function _G.Ntree_openLeft()
  local prevWindow = vim.api.nvim_get_current_win()
  local tabid = vim.api.nvim_get_current_tabpage()

  -- TODO: this function should not handle toggle
  if vim.tbl_get( Ntree_leftOpen, tabid ) ~= nil then
    local winid = Ntree_leftOpen[ tabid ]
    -- check if winid is open as it could be closed via c-w dd
    if vim.fn.index( vim.api.nvim_tabpage_list_wins( tabid ), winid ) ~= -1 then
      Ntree_close( nil, winid )
      Ntree_leftOpen[tabid] = nil
      return
    end
  end

  local reveal_file = vim.fn.expand( "%:p" )
  reveal_file = reveal_file ~= "" and reveal_file or vim.fn.MostRecentlyUsedLocalFile()
  local cwd = vim.fn.getcwd( vim.fn.winnr() )
  vim.api.nvim_set_current_win( vim.fn.win_getid( 1 ) )
  vim.cmd( "leftabove 29vnew" )
  vim.cmd "set winfixwidth"
  Ntree_launch( reveal_file, cwd )
  Ntree_leftOpen[tabid] = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win( prevWindow )
end

function _G.Ntree_openRight()
  local prevWindow = vim.api.nvim_get_current_win()
  local tabid = vim.api.nvim_get_current_tabpage()

  -- TODO: this function should not handle toggle
  if vim.tbl_get( Ntree_rightOpen, tabid ) ~= nil then
    local winid = Ntree_rightOpen[ tabid ]
    -- check if winid is open as it could be closed via c-w dd
    if vim.fn.index( vim.api.nvim_tabpage_list_wins( tabid ), winid ) ~= -1 then
      Ntree_close( nil, winid )
      Ntree_rightOpen[tabid] = nil
      return
    end
  end

  local reveal_file = vim.fn.expand( "%:p" )
  local cwd = vim.fn.getcwd( vim.fn.winnr() )
  local winIdsInTab = vim.api.nvim_tabpage_list_wins( tabid )
  vim.api.nvim_set_current_win( winIdsInTab[# winIdsInTab] )
  vim.cmd( "29vnew" )
  vim.cmd "set winfixwidth"
  Ntree_launch( reveal_file, cwd )
  Ntree_rightOpen[tabid] = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win( prevWindow )
end

-- Ntree_rightOpen
-- vim.api.nvim_tabpage_list_wins( 2 )

function _G.Ntree_openFloat()
  local prevWindow = vim.api.nvim_get_current_win()
  local posOpts = FloatOpts_inOtherWinColumn()
  posOpts.width = math.floor( posOpts.width / 2.0 )
  local bufid = vim.api.nvim_create_buf( false, true )

  local reveal_file = vim.fn.expand( "%:p" )
  local cwd = vim.fn.getcwd( vim.fn.winnr() )

  local floating_winId = vim.api.nvim_open_win( bufid, false, posOpts )
  vim.g['floating_win'] = floating_winId
  vim.api.nvim_set_current_win(floating_winId)
  Ntree_launch( reveal_file, cwd )
  vim.api.nvim_set_current_win( prevWindow )
end


-- vim.api.nvim_get_current_win()
-- vim.api.nvim_set_current_win(1231)
-- vim.cmd('leftabove vnew')


local function open_startup()
  Ntree_openLeft()
end

-- vim.fn.NewBufCmds( "" )[ 'left' ]
-- vim.cmd( vim.fn.NewBufCmds( "" )[ 'left' ] )

vim.keymap.set( 'n', '<leader>oa', Ntree_openLeft )
vim.keymap.set( 'n', '<leader>ov', Ntree_openRight )
vim.keymap.set( 'n', '<leader>oo', Ntree_openFloat )

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function() vim.defer_fn( open_startup, 10 ) end })


_G.Ntree_setCwd = f.curry3( function( source, scope, state )
  local path
  if source == 'fromNode' then
    local node = state.tree:get_node()
    path = node:get_id()
  else
    path = state.path
  end

  if scope == 'update' then
    vim.fn.chdir( path )
  elseif scope == 'local' then
    vim.cmd ( 'lcd ' .. path )
  elseif scope == 'tab' then
    vim.cmd ( 'tcd ' .. path )
  elseif scope == 'global' then
    vim.cmd ( 'cd ' .. path )
  end
end )


-- ─^  Helpers                                           ▲

-- this is my component definition AI.
local select_status = {
  name = "select_status",
  renderer = function(config, node, state)
    if state.is_selected(node.id) then
      return { { text = "◌", highlight = "NeoTreeFileIcon" } }
    else
      return { { text = "-", highlight = "Comment" } }
    end
  end,
}

-- ─   Config                                            ■

require("neo-tree").setup({

  log_level = 'warn',

  hide_root_node = true, -- Hide the root node.
  -- auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions

  -- event_handlers = {
  --   {
  --     event = "neo_tree_buffer_enter",
  --     handler = function() vim.fn.StatusLine_neotree() end,
  --   },
  --   {
  --     event = "neo_tree_buffer_leave",
  --     handler = function() vim.fn.StatusLine_default() end,
  --   },
  --   {
  --     event = "neo_tree_popup_buffer_enter",
  --     handler = function() vim.fn.StatusLine_default() end,
  --   },
  -- },

  renderers = {
    -- This overwrites the "directory" renderer. This is actually the default copied from ~/.config/nvim/scratch/neo-tree-defaults.sct‖:260:5
    -- The only difference is that the "icon" component is not in the returned list of textproducing functions / component names.
    directory = {
      -- { "indent" },
      -- { "icon" },
      { "current_filter" },
      {
        "container",
        content = {
          { "name", zindex = 10 },
          {
            "symlink_target",
            zindex = 10,
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          { "clipboard", zindex = 10 },
          { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
          { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
          { "file_size", zindex = 10, align = "right" },
          { "type", zindex = 10, align = "right" },
          { "last_modified", zindex = 10, align = "right" },
          { "created", zindex = 10, align = "right" },
        },
      },
    },

    file = {
      -- { "indent" },
      { "icon" },
      { "select_status" },
      {
        "container",
        content = {
          {
            "name",
            zindex = 10
          },
          {
            "symlink_target",
            zindex = 10,
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          { "clipboard", zindex = 10 },
          { "bufnr", zindex = 10 },
          { "modified", zindex = 20, align = "right" },
          { "diagnostics",  zindex = 20, align = "right" },
          { "git_status", zindex = 10, align = "right" },
          { "file_size", zindex = 10, align = "right" },
          { "type", zindex = 10, align = "right" },
          { "last_modified", zindex = 10, align = "right" },
          { "created", zindex = 10, align = "right" },
          -- I want to add my component here. but i need to register it first so neo-tree can find it. AI!
          -- { "select_status", zindex = 10, align = "right" },
        },
      },
    },


    -- root = {
    --   -- {"indent"},
    --   {"icon", default="C" },
    --   {"name", zindex = 10},
    -- },


  },


  default_component_configs = {

    indent = {
        -- padding = 0,
        with_markers = false,
        indent_marker = "",
        last_indent_marker = "",
        indent_size = 2,

        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",

    },

    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      folder_empty_open = "",
      default = "",
      highlight = "NeoTreeFileIcon"
      -- folder_closed = "",
      -- folder_open = "",
      -- folder_empty = "󰉖",
      -- folder_empty_open = "󰷏",
    },

    symbols = {
      -- Change type
      added     = "✚",
      deleted   = "✖",
      modified  = "",
      renamed   = "󰁕",
      -- Status type
      untracked = "",
      -- ignored   = "",
      ignored   = "◌",
      unstaged  = "󰄱",
      staged    = "",
      conflict  = "",
    },

    git_status = {
      symbols = {
        -- Change type
        added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
        deleted   = "✖",
        modified  = "",
        renamed   = "󰁕",
        -- Status type
        untracked = "",
        ignored   = "◌",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      },
    },


    -- note these highlights:
    -- NeoTreeGitAdded
    -- NeoTreeGitConflict
    -- NeoTreeGitDeleted
    -- NeoTreeGitIgnored
    -- NeoTreeGitModified
    -- NeoTreeGitUntracked
  },

    window = {

      width = 33, -- applies to left and right positions

-- ─   Global mappings                                  ──
      mappings = {

      --   -- What is this?!
        -- ["<space>"] = {
        --   "toggle_node",
        --   nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        -- },

        ["<C-v>"] = function() vim.cmd("normal! V") end,

        ["<C-v>"] = function() vim.cmd("normal! V") end,

        ["<c-f>"] = function() Tab_go_offset(  1 ) end,
        ["<c-d>"] = function() Tab_go_offset( -1 ) end,

        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        -- ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ["<esc>"] = "noop", -- TODO close preview ..
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["<space>P"] = { "toggle_preview", config = { use_float = false } },

        -- ["l"] = "focus_preview",
        ["l"] = "noop",  -- use c-w i
        -- ["s"] = "open_split",
        -- ["S"] = "split_with_window_picker",
        -- ["s"] = "vsplit_with_window_picker",
        ["t"] = "noop",
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ["i"] = Ntree_expandFile_saveView,
        ["I"] = "open",
        ["O"] = open_all_subnodes,
        ["zo"] = open_all_subnodes,
        ["Y"] = "close_node",
        ["zc"] = "close_all_subnodes",
        ["zC"] = "close_all_nodes",
        ["w"] = "noop",
        ["C"] = "close_node",
        ["z"] = "noop",
        --["Z"] = "expand_all_nodes",
        ["R"] = "refresh",
        ["<space>to"] = {
          "add",
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          }
        },

        ["."] = "noop",
        ["e"] = "noop",
        ["d"] = "noop",
        ["r"] = "noop",
        ["y"] = "noop",
        ["x"] = "noop",
        ["m"] = "noop",
        ["A"] = "noop",
        -- ["go"] = "noop",

        ["oc"] = "noop",
        ["od"] = "noop",
        ["og"] = "noop",
        ["om"] = "noop",
        ["on"] = "noop",
        ["os"] = "noop",
        ["ot"] = "noop",

        ["=="] = "toggle_auto_expand_width",
        ["q"] = Ntree_close,
        ["g?"] = "show_help",
        ["?"] = "noop",
        ["<"] = "prev_source",
        [">"] = "next_source",

-- ─   Motions                                          ──
        [")"] = function() vim.cmd("normal! j^") end,
        ["*"] = function() vim.cmd("normal! k^") end,


        -- TODO: does this work with other sources than filesystem?
        ["<leader>-"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          fs.navigate(state, vim.fn.getcwd(), current_path, nil, false)
        end,
        [",,i"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          fs.navigate(state, vim.fn.getcwd(), current_path, nil, false)
        end,

        ["p"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'preview_back', s.tree:get_node().path ) end,
        ["o"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'float', s.tree:get_node().path ) end,
        ["tn"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'tab', s.tree:get_node().path ) end,
        ["Tn"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'tab_bg', s.tree:get_node().path ) end,
        -- _
        ["v"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'right', s.tree:get_node().path ) end,
        ["V"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'right_back', s.tree:get_node().path ) end,
        ["a"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'left', s.tree:get_node().path ) end,
        ["u"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'up', s.tree:get_node().path ) end,
        ["U"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'up_back', s.tree:get_node().path ) end,
        ["s"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'down', s.tree:get_node().path ) end,
        ["S"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'down_back', s.tree:get_node().path ) end,

        ["<localleader>v"] = function(s)
          local path = s.tree:get_node().path
          local cmd = vim.fn.NewBufCmds( path )[ 'right' ]
          Ntree_cmdInOriginWin( cmd )
        end,

        ["<localleader>s"] = function(s)
          local path = s.tree:get_node().path
          local cmd = vim.fn.NewBufCmds( path )[ 'down' ]
          Ntree_cmdInOriginWin( cmd )
        end,

        ["<localleader>a"] = function(s)
          local path = s.tree:get_node().path
          local cmd = "leftabove vnew " .. path
          Ntree_cmdInOriginWin( cmd )
        end,

        ["<localleader>u"] = function(s)
          local path = s.tree:get_node().path
          local cmd = "leftabove 20new " .. path
          Ntree_cmdInOriginWin( cmd )
        end,


        ["<localleader>i"] = function(s)
          local path = s.tree:get_node().path
          local cmd = vim.fn.NewBufCmds( path )[ 'full' ]
          Ntree_cmdInOriginWin( cmd )
        end,

        ["<leader>td"] = function(s) Tablabel_set_folder( s.tree:get_node().path ) end,


        ["<c-space>"] = Ntree_close_saveView_showFolderInDirvish,
        ["<localleader>di"] = Ntree_close_saveView_showFolderInDirvish,

        ["gq"] = Ntree_close_saveView_restoreAltFileLoc,

        -- Set the project root / CWD
        ["<leader>cdpl"] = Ntree_setCwd( 'fromTreeRoot', 'local' ),
        ["<leader>cdpt"] = Ntree_setCwd( 'fromTreeRoot', 'tab' ),
        ["<leader>cdpg"] = Ntree_setCwd( 'fromTreeRoot', 'global' ),
        ["<leader>cdpu"] = Ntree_setCwd( 'fromTreeRoot', 'update' ),
        ["<leader>cdnl"] = Ntree_setCwd( 'fromNode', 'local' ),
        ["<leader>cdnt"] = Ntree_setCwd( 'fromNode', 'tab' ),
        ["<leader>cdng"] = Ntree_setCwd( 'fromNode', 'global' ),
        ["<leader>cdnu"] = Ntree_setCwd( 'fromNode', 'update' ),

        -- Set the 
        ["<leader>cdps"] =  function(s)
          local path = s.tree:get_node().path
          vim.fn.SbtJs_setProject( path )
        end,

        -- ["go"] = function()
        --   vim.cmd( 'wincmd p' )
        --   vim.cmd( 'Telescope find_files hidden=true' )
        -- end,

        -- ["go"] = function()
        --   vim.fn.StatusLine_default()
        --   -- vim.fn.T_DelayedCmd( "Telescope find_files hidden=true", 1000 )
        -- end,


      },

      popup = {
        position = { col = "100%", row = "2" },
        size = function(state)
          local root_name = vim.fn.fnamemodify(state.path, ":~")
          local root_len = string.len(root_name) + 4
          return {
            width = math.max(root_len, 50),
            height = vim.o.lines - 6
          }
        end
      },

    },


  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols",
    "diagnostics",
    "netman.ui.neo-tree",
  },

  filesystem = {


    components = {

      -- name = function(config, node)
      --   return {
      --     text = node.name .. " hi",
      --     highlight = "NeoTreeFileName"
      --   }
      -- end,

      -- icon = icon,

    },

    group_empty_dirs = false, -- when true, empty directories will be grouped together
    find_by_full_path_words = true,  -- if true use space as implicit .*  e.g. "fil init" for filesystem/init

-- ─   Filesystem mappings                              ──
    window = {
      mappings = {
        ["<space>/"] = "fuzzy_finder",
        ["<space><space>/"] = "filter_as_you_type",
        ["/"] = "noop",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["<space>f"] = "filter_on_submit",
        ["f"] = "noop",
        ["<C-x>"] = "clear_filter",
        ["<bs>"] = "navigate_up",
        ["-"] = "navigate_up",
        ["."] = "set_root",
        ["<space>b"] = "set_root",
        ["<space>scm"] = "toggle_node",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",

        ["<space>mk"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["<space>dd"] = "delete",
        ["<space>lr"] = "rename",  -- as "l re" is used for rcmd / rlist maps. "l lr" should be consistent with lsp rename

        ["yy"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          vim.fn.ClipBoard_LinkPath( current_path, "", 'shorten' )
        end,

        ["<leader>cp"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          vim.fn.ClipBoard_LinkPath( current_path, "", 'shorten' )
        end,

        ["<leader>cP"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          vim.fn.ClipBoard_LinkPath( current_path, "", 'full' )
        end,

        -- ["<leader>cP"] = function(state)
        --   local node = state.tree:get_node()
        --   local current_path = node:get_id()
        --   vim.fn.ClipBoard_LinkPath( current_path, "", 'full' )
        -- end,

        ["gee"] = function()
          vim.cmd 'wincmd p'
          vim.fn.T_Menu()
        end,

        ["<leader>Os"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          vim.cmd( "silent !open " .. current_path )
        end,

        ["<leader>Oc"] = function(state)
          local node = state.tree:get_node()
          local current_path = node:get_id()
          vim.cmd( "silent !code " .. current_path )
        end,

        -- SELECTION COMMANDS
        -- there are just COPY and CUT selection commands
        --    quick moves:
        ["c"] = function( state, callback )
          common_commands.copy_to_clipboard( state, callback )
          renderer.focus_node(state, nil, true, 1, 3)
          renderer.redraw(state)
        end,
        ["x"] = function( state, callback )
          common_commands.cut_to_clipboard( state, callback )
          renderer.focus_node(state, nil, true, 1, 3)
          renderer.redraw(state)
        end,

        --    Batch marking all of visual selection:
        ["<space>yy"] = "copy_to_clipboard",
        ["<space>xx"] = "cut_to_clipboard",

        -- EXECUTE SELECTION
        -- this executes the currently selected nodes (based on their selection type)
        -- TODO: test with mixed selection types.
        ["<space>pp"] = "paste_from_clipboard",


        -- TODO test these
        ["<space>yd"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["<space>mv"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options

        ["<space>H"] = "toggle_hidden",
        ["H"] = "noop",
        ["<space>K"] = "show_file_details",
        ["<space><space>K"] = function(state)
            local node = state.tree:get_node()
            putt(node)
          end,
        ["<space><space>o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
        ["<space><space>oc"] = { "order_by_created", nowait = false },
        ["<space><space>od"] = { "order_by_diagnostics", nowait = false },
        ["<space><space>og"] = { "order_by_git_status", nowait = false },
        ["<space><space>om"] = { "order_by_modified", nowait = false },
        ["<space><space>on"] = { "order_by_name", nowait = false },
        ["<space><space>os"] = { "order_by_size", nowait = false },
        ["<space><space>ot"] = { "order_by_type", nowait = false },
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
      },
    },

    bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
    cwd_target = {
      sidebar = "tab",   -- sidebar is when position = left or right
      current = "window" -- current is when position = current
    },

    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
        --"node_modules",
      },
      hide_by_pattern = {
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        ".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
        "thumbs.db",
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },

    hijack_netrw_behavior = "disabled",

  },


  diagnostics = {
    auto_preview = { -- May also be set to `true` or `false`
      enabled = false, -- Whether to automatically enable preview mode
      preview_config = {}, -- Config table to pass to auto preview (for example `{ use_float = true }`)
      event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
    },
    bind_to_cwd = true,
    diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
    -- "position" means diagnostic items are sorted strictly by their positions.
    -- May also be a function.
    follow_current_file = { -- May also be set to `true` or `false`
      enabled = true, -- This will find and focus the file in the active buffer every time
      always_focus_file = false, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
      expand_followed = true, -- Ensure the node of the followed file is expanded
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      leave_files_open = false, -- `false` closes auto expanded files, such as with `:Neotree reveal`
    },
    group_dirs_and_files = true, -- when true, empty folders and files will be grouped together
    group_empty_dirs = false, -- when true, empty directories will be grouped together
    show_unloaded = true, -- show diagnostics from unloaded buffers
    refresh = {
      delay = 100, -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
      event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
      -- Set to `false` or `"none"` to disable automatic refreshing
      max_items = 10000, -- The maximum number of diagnostic items to attempt processing
      -- Set to `false` for no maximum
    },
  },


})


-- ─^  Config                                            ▲









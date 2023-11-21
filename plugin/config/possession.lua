
local Path = require('plenary.path')
local f = require 'utils.functional'

local manager = require('neo-tree.sources.manager')
local renderer = require('neo-tree.ui.renderer')
local command = require('neo-tree.command')
local fs = require("neo-tree.sources.filesystem")

-- in the save hook, switch all neotree buffers to its alternative file
-- see if this gets persisted.
-- also set a buffer var on these alt buffers and see if this is persisted
-- neotreeid = <winid>
-- then on session load post, loop through all buffers and find neotree data by winid
-- and set state 'current' for the alt file/buffer
--

-- -- using a hook i can safe a big data structure



-- ─   Helpers                                           ■


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


function _G.Ntree_get_session_state()
  return vim.iter( vim.api.nvim_list_tabpages() )
    :map( function(tabnr)
      return vim.api.nvim_tabpage_list_wins( tabnr )
    end)
    :map( function(winids)
      return vim.tbl_map( function(winid)
        local bid = vim.api.nvim_win_get_buf( winid )
        local filetype = vim.api.nvim_buf_get_option( bid, 'filetype' )
        if filetype == 'neo-tree' then
          return _G.Ntree_get_state( winid )
        else
          return {}
        end
      end, winids )
    end)
    :totable()
end

-- Ntree_session_state()
-- vim.api.nvim_list_tabpages()

-- function _G.Ntree_session_switchToAltFile() ■
--   return vim.iter( vim.api.nvim_list_tabpages() )
--     :map( function(tabidx)
--       return vim.api.nvim_tabpage_list_wins( tabidx )
--     end)
--     :map( function(winids)
--       return vim.tbl_map( function(winid)
--         if vim.fn.exists( vim.w[winid]["AlternateFileLoc"] ) then
--           vim.w[winid]["AlternateFileLoc"]
--         -- from the current winid get altfileloc string
--         if exists(alt then
--         -- winid get bufid
--         local bid = vim.api.nvim_win_get_buf( winid )
--           -- need the bufferid.
--            vim.fn.AlternateFileLoc_restore( 'edit' )
--           -- return { winid }
--         else
--           return {}
--         end
--       end, winids )
--     end)
--     :totable()
-- end ▲

function _G.Ntree_set_session_state( sessionTreeViewData )
  vim.iter( ipairs( sessionTreeViewData ) )
  :each( function( tabnr, tabTreeViewData )
    vim.iter( ipairs( tabTreeViewData ) )
    :each( function( winnr, winTreeViewData )
      if not vim.tbl_isempty( winTreeViewData ) then
        local tabId = vim.api.nvim_list_tabpages()[ tabnr ]
        local winId = vim.api.nvim_tabpage_list_wins( tabId )[ winnr ]

        local state = manager.get_state('filesystem', tabId, winId)
        state.current_position = 'current'
        state.force_open_folders = winTreeViewData.expanded_paths
        state.filtered_items.visible = winTreeViewData.filter_visible
        renderer.acquire_window( state )
        Ntree_launch_inWin( state, winTreeViewData, winId )
      end
    end )
  end)
end

-- Ntree_set_session_state( { {}, { {}, { expanded_paths = { "/Users/at/.config/nvim/plugin" }, filter_visible = true, focus_path = "/Users/at/.config/nvim/plugin/config/neo-tree.lua", root_path = "/Users/at/.config/nvim/plugin" } } } )


-- vim.api.nvim_buf_set_var(state.bufnr, "neo_tree_source", state.name)
-- vim.api.nvim_buf_set_var(state.bufnr, "neo_tree_tabnr", state.tabnr)
-- vim.api.nvim_buf_set_var(state.bufnr, "neo_tree_position", state.current_position)
-- vim.api.nvim_buf_set_var(state.bufnr, "neo_tree_winid", state.winid)

-- vim.api.nvim_buf_get_var( 218, "neo_tree_source")
-- vim.api.nvim_buf_get_var( 1, "neo_tree_source")
-- buffers!


-- function _G.Nttest(winTreeViewData) ■
--   -- local winId = vim.api.nvim_tabpage_list_wins( 1 )[ 1347 ]
--   -- local newState = manager.get_state('filesystem', 2, 1347)
--   -- -- newState.current_position = 'current'
--   -- Ntree_view_set( winTreeViewData, newState )
--   -- manager.navigate( newState )
--   -- create a new tree for this window
--   local state = manager.get_state("filesystem", 2, 1003)
--   local focus_path = "/Users/at/.config/nvim/plugin/config/neo-tree.lua"
--   -- state.path = focus_path
--   state.current_position = "current"
--   state.force_open_folders = { "/Users/at/.config/nvim/plugin" }
--   -- require("neo-tree.sources.filesystem")._navigate_internal(state, nil, nil, nil, false)
--   fs._navigate_internal(state, "/Users/at/.config/nvim/plugin", focus_path, nil, false)
-- end
--  ▲
-- Nttest( { expanded_paths = { "/Users/at/.config/nvim/plugin" }, filter_visible = true, focus_path = "/Users/at/.config/nvim/plugin/config/neo-tree.lua", root_path = "/Users/at/.config/nvim/plugin" } )

-- require("neo-tree.sources.manager").get_state('filesystem', 1, 1003)

function _G.Ntree_get_state( winid )
  local state = manager.get_state_for_window( winid )
  if not state then return end
  local treeView = Ntree_view_get( state )
  local altFileLoc = { 
    AlternateFileLoc = 
      vim.fn.exists( vim.w[winid]["AlternateFileLoc"] )
      and vim.w[winid]["AlternateFileLoc"]
      or "",
  }

  return f.merge( altFileLoc, treeView )
end

-- lua putt( Ntree_get_state( vim.fn.win_getid() ) )


-- _G.Ntree_set_state = function(data)
--   command.execute({
--     action = 'show',
--     dir = data['path'],
--   })
  -- local state = manager.get_state_for_window( winid )
--   state.filtered_items.visible = data['show_hidden']
--   state.force_open_folders = data['expanded_nodes']
-- end



-- ─^  Helpers                                           ▲


-- ─   Config                                           ──

require('possession').setup {

  session_dir = (Path:new(vim.fn.stdpath('data')) / 'possession'):absolute(),
  silent = false,
  load_silent = true,
  debug = false,
  logfile = false,
  prompt_no_cr = false,
  autosave = {
    current = true,  -- or fun(name): boolean
    tmp = false,  -- or fun(): boolean
    tmp_name = 'tmp', -- or fun(): string
    on_load = true,
    on_quit = true,
  },

  commands = {
    save = 'PossessionSave',
    load = 'PossessionLoad',
    rename = 'PossessionRename',
    close = 'PossessionClose',
    delete = 'PossessionDelete',
    show = 'PossessionShow',
    list = 'PossessionList',
    migrate = 'PossessionMigrate',
  },

-- ─   Hooks                                            ──

  hooks = {

    before_save = function( _name )
      local res = {}

      local neo_state = Ntree_get_session_state()
      if neo_state ~= nil then
        res['neo_tree'] = neo_state
      end

      res['tabs_hidden'] = Tabs_hidden_indexs()
      res['tabs_show_hidden'] = Tabs_show_hidden
      res['repl_is_running'] = type( vim.g["ScalaReplID"] ) == 'number' and true or false
      res['server_repl_is_running'] = type( vim.g["ScalaServerReplID"] ) == 'number' and true or false

      return res
    end,

    -- before_save = function( _name )
    --   local res = {}
    --   local neo_state = neo_get_state()
    --   if neo_state ~= nil then
    --     res['neo_tree'] = neo_state
    --   end
    --   return res
    -- end,
    -- after_save = function(name, user_data, aborted) end,
    -- before_load = function(name, user_data) return user_data end,
    after_load = function(name, user_data)
      if user_data['neo_tree'] ~= nil then
        Ntree_set_session_state(user_data['neo_tree'])
      end

      if user_data['tabs_hidden'] ~= nil then
        _G.Tabs_hidden      = user_data['tabs_hidden']
        _G.Tabs_show_hidden = user_data['tabs_show_hidden']
      end

      if user_data['repl_is_running'] ~= nil and user_data['repl_is_running'] == true then
        -- Start a repl in the background, setting g:ScalaReplID.
        vim.fn.ScalaReplStart()
      end

      if user_data['server_repl_is_running'] ~= nil and user_data['server_repl_is_running'] == true then
        -- Start a repl in the background, setting g:ScalaServerReplID.
        vim.fn.ScalaServerReplStart()
      end

    end,
  },


-- ─   Plugins                                          ──

  plugins = {
    close_windows = {
      hooks = {'before_save', 'before_load'},
      preserve_layout = true,  -- or fun(win): boolean
      match = {
        floating = true,
        buftype = {'terminal'},
        filetype = {},
        custom = false,  -- or fun(win): boolean
      },
    },
    delete_hidden_buffers = {
      hooks = {
        'before_load',
        vim.o.sessionoptions:match('buffer') and 'before_save',
      },
      -- no effect?
      force = function(buf) return vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' end
    },
    symbols_outline = true,
    neo_tree = false,
    nvim_tree = false,
    tabby = true,
    dap = true,
    dapui = true,
    delete_buffers = false,
  },
  telescope = {
    list = {
      default_action = 'load',
      mappings = {
        save = { n = '<c-x>', i = '<c-x>' },
        load = { n = '<c-v>', i = '<c-v>' },
        delete = { n = '<c-t>', i = '<c-t>' },
        rename = { n = '<c-r>', i = '<c-r>' },
      },
    },
  },
}



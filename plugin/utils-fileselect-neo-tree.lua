

vim.g.neo_tree_remove_legacy_commands = 1


-- All config default values: 
-- /Users/at/.vim/scratch/neo-tree-defaults.sct
-- ~/.config/nvim/plugged/neo-tree.nvim/lua/neo-tree/defaults.lua

local tree_exec = require 'neo-tree.command'.execute
local manager = require 'neo-tree.sources.manager'
local fs = require("neo-tree.sources.filesystem")
-- local Preview = require("neo-tree.sources.common.preview")

-- ─   Helpers                                           ■

function _G.Ntree_currentNode()
  local state = manager.get_state_for_window()
  return {
    rootpath = state.path,
    linepath = state.position.node_id
  }
end

function _G.TreeRoot_infoStr( rootPath )
  local lpath = vim.split( rootPath, [[/]] )
  local dir = lpath[ #lpath ]
  local parentDir = lpath[ #lpath -1 ]
  return dir ,parentDir
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


function _G.Ntree_launch( reveal_path, root_dir)
  tree_exec({
    position = "current",
    dir = root_dir,
    reveal_file = reveal_path,
    reveal_force_cwd = true,
  })
end


-- ─^  Helpers                                           ▲


-- ─   Config                                            ■

require("neo-tree").setup({

  hide_root_node = true, -- Hide the root node.

  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function() vim.fn.StatusLine_neotree() end,
    },
    {
      event = "neo_tree_buffer_leave",
      handler = function() vim.fn.StatusLine_default() end,
    },
  },

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

      mappings = {

        ["<space>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
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
        -- ["t"] = "open_tabnew",
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ["i"] = "open",
        ["I"] = "open",
        ["zo"] = "open",
        ["Y"] = "close_node",
        ["zc"] = "close_node",
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

        ["e"] = "noop",
        ["d"] = "noop",
        ["r"] = "noop",
        ["y"] = "noop",
        ["x"] = "noop",
        ["m"] = "noop",
        ["A"] = "noop",
        ["go"] = "noop",

        ["oc"] = "noop",
        ["od"] = "noop",
        ["og"] = "noop",
        ["om"] = "noop",
        ["on"] = "noop",
        ["os"] = "noop",
        ["ot"] = "noop",

        ["=="] = "toggle_auto_expand_width",
        ["q"] = "close_window",
        ["g?"] = "show_help",
        ["?"] = "noop",
        ["<"] = "prev_source",
        [">"] = "next_source",


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
        ["t"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'tab', s.tree:get_node().path ) end,
        ["T"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'tab_bg', s.tree:get_node().path ) end,
        -- _
        ["v"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'right', s.tree:get_node().path ) end,
        ["V"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'right_back', s.tree:get_node().path ) end,
        ["a"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'left', s.tree:get_node().path ) end,
        ["u"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'up', s.tree:get_node().path ) end,
        ["U"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'up_back', s.tree:get_node().path ) end,
        ["s"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'down', s.tree:get_node().path ) end,
        ["S"] = function(s) vim.fn.NewBuf_fromCursorLinkPath( 'down_back', s.tree:get_node().path ) end,


        ["<c-space>"] = function(state)
            local path = state.tree:get_node().path
            local folder = vim.fn.fnamemodify( path, ":h" )
            vim.cmd( "edit " .. folder )
            vim.fn.SearchLine( path )
            tree_exec({ action = "close" })
          end,

        ["gq"] = function()
            vim.fn.AlternateFileLoc_restore( 'edit' )
            tree_exec({ action = "close" })
          end,


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

    group_empty_dirs = true, -- when true, empty directories will be grouped together
    find_by_full_path_words = true,  -- if true use space as implicit .*  e.g. "fil init" for filesystem/init

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
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",

        ["<space>mk"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["<space>dd"] = "delete",
        ["<space>lr"] = "rename",  -- as "l re" is used for rcmd / rlist maps. "l lr" should be consistent with lsp rename
        ["<space>yy"] = "copy_to_clipboard",
        ["<space>xx"] = "cut_to_clipboard",
        ["<space>pp"] = "paste_from_clipboard",
        ["<space>yd"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["<space>mv"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options

        ["<space>H"] = "toggle_hidden",
        ["H"] = "noop",
        ["<space>K"] = "show_file_details",
        ["<space><space>K"] = function(state)
            local node = state.tree:get_node()
            vim.print(node.path)
          end,
        ["<space>o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
        ["<space>oc"] = { "order_by_created", nowait = false },
        ["<space>od"] = { "order_by_diagnostics", nowait = false },
        ["<space>og"] = { "order_by_git_status", nowait = false },
        ["<space>om"] = { "order_by_modified", nowait = false },
        ["<space>on"] = { "order_by_name", nowait = false },
        ["<space>os"] = { "order_by_size", nowait = false },
        ["<space>ot"] = { "order_by_type", nowait = false },
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
    group_empty_dirs = true, -- when true, empty directories will be grouped together
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


local function open_normal()
  tree_exec({
    action = "show",
    position = "left",
  })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_normal })

-- require("neo-tree.command").execute({ action = "show", position = "right" })
-- require("neo-tree.command").execute({ action = "close", position = "right" })


-- ─   Helpers                                           ■ ■

local highlights = require("neo-tree.ui.highlights")

local filtered_by = function(config, node, state)
  local result = {}
  if type(node.filtered_by) == "table" then
    local fby = node.filtered_by
    if fby.name then
      result = {
        text = "(hide by name)",
        highlight = highlights.HIDDEN_BY_NAME,
      }
    elseif fby.pattern then
      result = {
        text = "(hide by pattern)",
        highlight = highlights.HIDDEN_BY_NAME,
      }
    elseif fby.gitignored then
      result = {
        text = "(gitignored)",
        highlight = highlights.GIT_IGNORED,
      }
    elseif fby.dotfiles then
      result = {
        text = "(dotfile)",
        highlight = highlights.DOTFILE,
      }
    elseif fby.hidden then
      result = {
        text = "(hidden)",
        highlight = highlights.WINDOWS_HIDDEN,
      }
    end
    fby = nil
  end
  return result
end


local icon = function(config, node, state)
  local icon = config.default or " "
  local highlight = config.highlight or highlights.FILE_ICON
  if node.type == "directory" then
    highlight = highlights.DIRECTORY_ICON
    if node.loaded and not node:has_children() then
      icon = not node.empty_expanded and config.folder_empty or config.folder_empty_open
    elseif node:is_expanded() then
      icon = config.folder_open or "-"
    else
      icon = config.folder_closed or "+"
    end
  elseif node.type == "file" or node.type == "terminal" then
    local success, web_devicons = pcall(require, "nvim-web-devicons")
    local name = node.type == "terminal" and "terminal" or node.name
    if success then
      local devicon, hl = web_devicons.get_icon(name)
      icon = devicon or icon
      highlight = hl or highlight
    end
  end
  local filtered = filtered_by(config, node, state)
  return {
    text = icon .. " ",
    highlight = filtered.highlight or highlight,
  }
end


-- ─^  Helpers                                           ▲ ▲





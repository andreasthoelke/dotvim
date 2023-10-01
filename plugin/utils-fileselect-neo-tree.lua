

-- DEFAULTS: use c-w lv ; \\sc 
-- /Users/at/.vim/scratch/neo-tree-defaults.sct
-- ~/.config/nvim/plugged/neo-tree.nvim/lua/neo-tree/defaults.lua


require("neo-tree").setup({

  hide_root_node = true, -- Hide the root node.

  default_component_configs = {

    indent = {
      padding = 0,
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
      folder_closed = " ",
      folder_open = "",
      folder_empty = "",
      folder_empty_open = "",
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

      mappings = {

        ["o"] = "noop",
        ["<space>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        -- ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ["<esc>"] = "noop", -- close preview or floating neo-tree window
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["l"] = "focus_preview",
        ["S"] = "open_split",
        -- ["S"] = "split_with_window_picker",
        ["s"] = "open_vsplit",
        -- ["s"] = "vsplit_with_window_picker",
        ["t"] = "open_tabnew",
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ["i"] = "open",
        ["I"] = "open",
        ["Y"] = "close_node",
        ["w"] = "noop",
        ["C"] = "close_node",
        ["zc"] = "close_all_nodes",
        --["Z"] = "expand_all_nodes",
        ["R"] = "refresh",
        ["<space>to"] = {
          "add",
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          }
        },

        ["e"] = "noop",
        ["d"] = "noop",
        ["r"] = "noop",
        ["y"] = "noop",
        ["x"] = "noop",
        ["p"] = "noop",

        ["=="] = "toggle_auto_expand_width",
        ["q"] = "close_window",
        ["g?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",

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

    group_empty_dirs = true, -- when true, empty directories will be grouped together

    window = {
      mappings = {
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        --["/"] = "filter_as_you_type", -- this was the default until v1.28
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<C-x>"] = "clear_filter",
        ["<bs>"] = "navigate_up",
        ["-"] = "navigate_up",
        ["."] = "set_root",
        ["<space>b"] = "set_root",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",

        ["<space>mk"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["<space>dd"] = "delete",
        ["<space>ree"] = "rename",
        ["<space>yy"] = "copy_to_clipboard",
        ["<space>xx"] = "cut_to_clipboard",
        ["<space>pp"] = "paste_from_clipboard",
        ["<space>yd"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["<space>mv"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options

        ["<space>K"] = "show_file_details",
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
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db",
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









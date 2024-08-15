-- Using buffer maps here: ~/.config/nvim/plugin/tools_scala.vim‖/nnoremapˍ<silent><buffer>ˍgedˍ:TroubleToggleˍworkspace_diagnostics<cr>:callˍT_DelayedCmd(ˍ"wincmdˍp",ˍ50ˍ)<cr>
-- nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
-- Todo: make these maps general per languge and put them here or
-- ~/.config/nvim/plugin/setup-lsp.vim#/nnoremap%20<silent><buffer>%20ger


-- ─   Trouble diagnostics                              ──

-- local trouble = require("trouble").setup {
--   position = "right", -- position of the list can be: bottom, top, left, right
--   height = 8, -- height of the trouble list when position is top or bottom
--   width = 50, -- width of the list when position is left or right
--   icons = true, -- use devicons for filenames
--   mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
--   fold_open = "", -- icon used for open folds
--   fold_closed = "", -- icon used for closed folds
--   group = true, -- group results by file
--   padding = false, -- add an extra new line on top of the list
--   action_keys = { -- key mappings for actions in the trouble list
--     -- map to {} to remove a mapping, for example:
--     -- close = {},
--     close = "q", -- close the list
--     cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
--     refresh = "r", -- manually refresh
--     jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
--     open_split = { "<c-x>" }, -- open buffer in new split
--     open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
--     open_tab = { "<c-t>" }, -- open buffer in new tab
--     jump_close = {"o"}, -- jump to the diagnostic and close the list
--     toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
--     toggle_preview = "P", -- toggle auto_preview
--     hover = "<leader>K", -- opens a small popup with the full multiline message
--     preview = "p", -- preview the diagnostic location
--     close_folds = {"zM", "zm"}, -- close all folds
--     open_folds = {"zR", "zr"}, -- open all folds
--     toggle_fold = {"zA", "za", "zo"}, -- toggle fold of current file
--     previous = "k", -- preview item
--     next = "j" -- next item
--   },
--   indent_lines = false, -- add an indent guide below the fold icons
--   auto_open = false, -- automatically open the list when you have diagnostics
--   auto_close = false, -- automatically close the list when you have no diagnostics
--   auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
--   auto_fold = false, -- automatically fold a file trouble list at creation
--   auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
--   signs = {
--     -- icons / text used for a diagnostic
--     error = "",
--     warning = "",
--     hint = "",
--     information = "",
--     other = "﫠"
--   },
--   use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
-- }

-- require'trouble'.open()

---@class trouble.Mode: trouble.Config,trouble.Section.spec
---@field desc? string
---@field sections? string[]

---@class trouble.Config
---@field mode? string
---@field config? fun(opts:trouble.Config)
---@field formatters? table<string,trouble.Formatter> custom formatters
---@field filters? table<string, trouble.FilterFn> custom filters
---@field sorters? table<string, trouble.SorterFn> custom sorters
local config = {
  auto_close = false, -- auto close when there are no items
  auto_open = false, -- auto open when there are items
  auto_preview = true, -- automatically open preview when on an item
  auto_refresh = true, -- auto refresh when open
  auto_jump = false, -- auto jump to the item when there's only one
  focus = false, -- Focus the window when opened
  restore = true, -- restores the last location in the list when opening
  follow = true, -- Follow the current item
  indent_guides = true, -- show indent guides
  max_items = 200, -- limit number of items that can be displayed per section
  multiline = true, -- render multi-line messages
  pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
  warn_no_results = true, -- show a warning when there are no results
  open_no_results = false, -- open the trouble window when there are no results
  ---@type trouble.Window.opts
  -- win = {}, -- window options for the results window. Can be a split or a floating window.

  win = {
    type = "float",
    relative = "editor",
    border = "rounded",
    title = "-",
    title_pos = "center",
    position = { 0, -2 },
    size = { width = 0.45, height = 0.2 },
    zindex = 200,
  },

  -- Window options for the preview window. Can be a split, floating window,
  -- or `main` to show the preview in the main editor window.
  ---@type trouble.Window.opts
  preview = {
    type = "main",
    -- when a buffer is not yet loaded, the preview window will be created
    -- in a scratch buffer with only syntax highlighting enabled.
    -- Set to false, if you want the preview to always be a real loaded buffer.
    scratch = true,
  },
  -- Throttle/Debounce settings. Should usually not be changed.
  ---@type table<string, number|{ms:number, debounce?:boolean}>
  throttle = {
    refresh = 20, -- fetches new data when needed
    update = 10, -- updates the window
    render = 10, -- renders the window
    follow = 100, -- follows the current item
    preview = { ms = 100, debounce = true }, -- shows the preview for the current item
  },
  -- Key mappings can be set to the name of a builtin action,
  -- or you can define your own custom action.
  ---@type table<string, trouble.Action.spec|false>
  keys = {
    ["?"] = "help",
    r = "refresh",
    R = "toggle_refresh",
    q = "close",
    o = "jump_close",
    ["<esc>"] = "cancel",
    ["<cr>"] = "jump",
    ["<2-leftmouse>"] = "jump",
    ["<c-s>"] = "jump_split",
    ["<c-v>"] = "jump_vsplit",
    -- go down to next item (accepts count)
    -- j = "next",
    ["}"] = "next",
    ["]]"] = "next",
    -- go up to prev item (accepts count)
    -- k = "prev",
    ["{"] = "prev",
    ["[["] = "prev",
    dd = "delete",
    d = { action = "delete", mode = "v" },
    i = "inspect",
    p = "preview",
    P = "toggle_preview",
    zo = "fold_open",
    zO = "fold_open_recursive",
    zc = "fold_close",
    zC = "fold_close_recursive",
    za = "fold_toggle",
    zA = "fold_toggle_recursive",
    zm = "fold_more",
    zM = "fold_close_all",
    zr = "fold_reduce",
    zR = "fold_open_all",
    zx = "fold_update",
    zX = "fold_update_all",
    zn = "fold_disable",
    zN = "fold_enable",
    zi = "fold_toggle_enable",
    gb = { -- example of a custom action that toggles the active view filter
      action = function(view)
        view:filter({ buf = 0 }, { toggle = true })
      end,
      desc = "Toggle Current Buffer Filter",
    },
    s = { -- example of a custom action that toggles the severity
      action = function(view)
        local f = view:get_filter("severity")
        local severity = ((f and f.filter.severity or 0) + 1) % 5
        view:filter({ severity = severity }, {
          id = "severity",
          template = "{hl:Title}Filter:{hl} {severity}",
          del = severity == 0,
        })
      end,
      desc = "Toggle Severity Filter",
    },
  },
  ---@type table<string, trouble.Mode>
  modes = {

    -- Note: Open these with Trouble preview_float/split. They are interesting. But I want preview in main window.
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
    preview_split = {
      mode = "diagnostics",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.5,
      },
    },

    cascade = {
      mode = "diagnostics", -- inherit from diagnostics mode
      filter = function(items)
        local severity = vim.diagnostic.severity.HINT
        for _, item in ipairs(items) do
          severity = math.min(severity, item.severity)
        end
        return vim.tbl_filter(function(item)
          return item.severity == severity
        end, items)
      end,
    },

    -- sources define their own modes, which you can use directly,
    -- or override like in the example below
    lsp_references = {
      -- some modes are configurable, see the source code for more details
      params = {
        include_declaration = true,
      },
    },
    -- The LSP base mode for:
    -- * lsp_definitions, lsp_references, lsp_implementations
    -- * lsp_type_definitions, lsp_declarations, lsp_command
    lsp_base = {
      params = {
        -- don't include the current location in the results
        include_current = false,
      },
    },
    -- more advanced example that extends the lsp_document_symbols
    symbols = {
      desc = "document symbols",
      mode = "lsp_document_symbols",
      focus = false,
      win = { position = "right" },
      filter = {
        -- remove Package since luals uses it for control flow structures
        ["not"] = { ft = "lua", kind = "Package" },
        any = {
          -- all symbol kinds for help / markdown files
          ft = { "help", "markdown" },
          -- default set of symbol kinds
          kind = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
  -- stylua: ignore
  icons = {
    ---@type trouble.Indent.symbols
    indent = {
      top           = "│ ",
      middle        = "├╴",
      last          = "└╴",
      -- last          = "-╴",
      -- last       = "╰╴", -- rounded
      fold_open     = " ",
      fold_closed   = " ",
      ws            = "  ",
    },
    folder_closed   = " ",
    folder_open     = " ",
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TypeParameter = " ",
      Variable      = "󰀫 ",
    },
  },
}

local trouble = require("trouble").setup( config )








local tree = require("nvim-tree.api").tree
local node = require("nvim-tree.api").node
local tree_lib = require("nvim-tree.lib")
local utils = require'utils_general'

local function tree_root_folder_label(path)
  -- return ".../" .. vim.fn.fnamemodify(path, ":t")
  local lpath = vim.split( path, [[/]] )
  local dir = lpath[ #lpath ]
  local parentDir = lpath[ #lpath -1 ]
  -- local parentStr = vim.fn.strpart( parentDir, 0, 4 )
  -- return parentStr .. " /" .. dir
  -- return dir .. " (" .. parentStr .. ")"
  return dir .. " |" .. parentDir
end



-- ─   NvimTree maps                                     ■

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- open({ winid = vim.api.nvim_get_current_win() })
  -- vim.keymap.set('n', 'i',     api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  -- vim.keymap.set('n', 'i',     tree.open({ winid = vim.api.nvim_get_current_win() }),     opts('Open: In Place'))
  -- vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  -- this opens an extra buffer to be replaced with an 'edit' command. seems inconsistent with my new setup.
  -- vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', ',i',    tree.change_root_to_parent,        opts('Up'))
  -- vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  -- vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  -- vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  -- see the custom maps for these: <leader>G in this case
  -- these seem quite useful
  vim.keymap.set('n', '[g',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']g',    api.node.navigate.git.next,            opts('Next Git'))
  -- vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  -- vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'zr',    api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'zR',    function() api.tree.collapse_all(true) end,     opts('Expand folders with open buffers'))
  vim.keymap.set('n', 'zC',    api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'zc',    function() api.tree.collapse_all(true) end,     opts('Collapse folders with no open buffers'))
  -- vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  -- vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  -- vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  -- vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  -- vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', ',j',    api.node.navigate.opened.next,        opts('Last Sibling'))
  vim.keymap.set('n', ',k',    api.node.navigate.opened.prev,        opts('First Sibling'))

  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  -- vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  -- vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'zo',    api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', '<c-]>', api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'I',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  -- TODO: is there a Collapse action? restrict to only folder nodes
  -- vim.keymap.set('n', 'Y',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'Y',     api.node.navigate.parent_close,        opts('Open: No Window Picker'))
  -- vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  -- vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  -- vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  -- vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  -- vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'yy',    api.fs.copy.filename,                  opts('Copy Name'))
  -- vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  vim.keymap.set('n', '<leader>-', Tree_setRootToCwd_keepFocuedNode, opts('Open'))
  vim.keymap.set('n', ',,i',       Tree_setRootToCwd_keepFocuedNode, opts('Open'))

  vim.keymap.set("n", "<leader>fd", find_directory_and_focus, opts('Find directory') )

  vim.keymap.set('n', 'p', function() vim.fn.NewBuf_fromCursorLinkPath('preview')  end, opts('preview'))
  vim.keymap.set('n', 'o', function() vim.fn.NewBuf_fromCursorLinkPath('float')    end, opts('float'))
  -- vim.keymap.set('n', 'i', function() vim.fn.NewBuf_fromCursorLinkPath('full')     end, opts('full'))
  vim.keymap.set('n', 't', function() vim.fn.NewBuf_fromCursorLinkPath('tab')      end, opts('tab'))
  vim.keymap.set('n', 'T', function() vim.fn.NewBuf_fromCursorLinkPath('tab_bg')   end, opts('tab_bg'))
  -- _                                                                             
  vim.keymap.set('n', 'v', function() vim.fn.NewBuf_fromCursorLinkPath('right')    end, opts('right'))
  vim.keymap.set('n', 'V', function() vim.fn.NewBuf_fromCursorLinkPath('right_bg') end, opts('right_bg'))
  vim.keymap.set('n', 'a', function() vim.fn.NewBuf_fromCursorLinkPath('left')     end, opts('left'))
  vim.keymap.set('n', 'u', function() vim.fn.NewBuf_fromCursorLinkPath('up')       end, opts('up'))
  vim.keymap.set('n', 'U', function() vim.fn.NewBuf_fromCursorLinkPath('up_bg')    end, opts('up_bg'))
  vim.keymap.set('n', 's', function() vim.fn.NewBuf_fromCursorLinkPath('down')     end, opts('down'))
  vim.keymap.set('n', 'S', function() vim.fn.NewBuf_fromCursorLinkPath('down_bg')  end, opts('down_bg'))

  vim.keymap.set('n', '<c-space>', function()
    local path = tree.get_node_under_cursor().absolute_path
    local folder = vim.fn.fnamemodify( path, ':h' )
    vim.cmd( vim.fn.NewBufCmds( folder )[ 'left' ] )
    vim.fn.SearchLine( path )
    vim.cmd 'wincmd p'
    tree.close()
  end, opts( 'switch to parent divish - focusing current file' ))

  vim.keymap.set('n', 'gq', function()
    local path = tree.get_node_under_cursor().absolute_path
    local folder = vim.fn.fnamemodify( path, ':h' )
    vim.cmd( vim.fn.NewBufCmds( folder )[ 'left' ] )
    -- vim.fn.feedkeys( utils.esc( '<Plug>(dirvish_quit)' ) )
    vim.fn.AlternateFileLoc_restore( 'edit' )
    vim.cmd 'wincmd p'
    tree.close()
  end, opts( 'Quit tree, open g:AlternateFileLoc in the same buffer' ))



-- nnoremap <silent><buffer>p :call NewBuf_fromCursorLinkPath("preview")<cr>
-- nnoremap <silent><buffer>o :call NewBuf_fromCursorLinkPath("float")<cr>
-- nnoremap <silent><buffer>i :call NewBuf_fromCursorLinkPath("full")<cr>
-- nnoremap <silent><buffer>t :call NewBuf_fromCursorLinkPath("tab")<cr>
-- nnoremap <silent><buffer>T :call NewBuf_fromCursorLinkPath("tab_bg")<cr>
-- " _
-- nnoremap <silent><buffer>v :call NewBuf_fromCursorLinkPath("right")<cr>
-- nnoremap <silent><buffer>V :call NewBuf_fromCursorLinkPath("right_bg")<cr>
-- nnoremap <silent><buffer>a :call NewBuf_fromCursorLinkPath("left")<cr>
-- nnoremap <silent><buffer>u :call NewBuf_fromCursorLinkPath("up")<cr>
-- nnoremap <silent><buffer>U :call NewBuf_fromCursorLinkPath("up_bg")<cr>
-- nnoremap <silent><buffer>s :call NewBuf_fromCursorLinkPath("down")<cr>
-- nnoremap <silent><buffer>S :call NewBuf_fromCursorLinkPath("down_bg")<cr>



-- v "right")<cr>
-- V "right_bg")<cr>
-- a "left")<cr>
-- u "up")<cr>
-- U "up_bg")<cr>
-- s "down")<cr>
-- S "down_bg")<cr>

  vim.keymap.set('n', 'i',     api.node.open.replace_tree_buffer,     opts('Open: In Place'))

  -- still consistent / useful?
  -- vim.keymap.set('n', 'i', api.node.open.edit, opts('Open'))
  -- vim.keymap.set('n', 'p', api.node.open.preview, opts('Open Preview'))

  -- consistent with dirvish?
  vim.keymap.set('n', '<leader>dd', api.fs.trash, opts('Trash'))
  vim.keymap.set('n', '<leader>yy', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', '<leader>re', api.fs.rename, opts('Rename'))
  -- useful filter views!?
  vim.keymap.set('n', '<leader>I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
  vim.keymap.set('n', '<leader>G', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  vim.keymap.set('n', '<leader>B', api.tree.toggle_no_buffer_filter, opts('Toggle no buffer'))
  vim.keymap.set('n', '<leader>C', api.tree.toggle_custom_filter, opts('Toggle custom filter'))

  -- not working? useful!? vs telescope file browser?
  vim.keymap.set('n', '<leader>/', api.tree.search_node, opts('Search'))

  -- not used much
  vim.keymap.set('n', '<leader>rf', api.node.run.cmd, opts('Run Command'))
  vim.keymap.set('n', '<leader>so', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', '<leader>re', api.fs.rename, opts('Rename'))

  vim.keymap.set('n', '<leader>pp', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
    node.fs.paste()
  end, opts('paste_file'))

  vim.keymap.set('n', '<leader>pP', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
    node.fs.paste_cut_file()
  end, opts('paste_cut_file'))

  vim.keymap.set('n', '<leader>o', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    tree_openFolderDirvish()

  end, opts('dirvish_folder'))

  vim.keymap.set('n', '<leader>i', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    tree_viewPathInPrevWin()
  end, opts('dirvish_folder'))

  vim.keymap.set('n', '<leader>b', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    local dir = tree.get_node_under_cursor().absolute_path
    api.tree.change_root(dir)

  end, opts('base_dir'))

  vim.keymap.set('n', 'T', function()
    local path = api.tree.get_node_under_cursor()
    api.node.open.tab(node)
    vim.cmd.tabprev()
  end, opts('open_tab_silent'))
end


-- ─^  NvimTree maps                                     ▲


-- First expands the tree, jumps back to the original win, then highlights the path
function _G.NvimTree_find_file( path )
  local api = require("nvim-tree.api")
  api.tree.focus()
  vim.cmd('wincmd p')
  api.tree.find_file( path )
end
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/H_Cats.scala"
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/resources/day03.in"
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/resources"

local function bookmNext()
  local api = require("nvim-tree.api")
  api.marks.navigate.next()
  api.marks.navigate.next()
end

local function bookmPrev()
  local api = require("nvim-tree.api")
  api.marks.navigate.prev()
  api.marks.navigate.prev()
end


local tree_api = require("nvim-tree.api")

vim.keymap.set("n", "]g", bookmNext)
vim.keymap.set("n", "[g", bookmPrev)
vim.keymap.set("n", "<leader>ms", require("nvim-tree.api").marks.navigate.select)

-- local aa = require("nvim-tree.api").fs.copy.



-- source
-- /Users/at/.config/nvim/plugged/nvim-tree.lua/

-- API
-- ~/.config/nvim/plugged/nvim-tree.lua/doc/nvim-tree-lua.txt#/-%20api.fs.%20*nvim-tree.api.fs*
-- ~/.config/nvim/plugged/nvim-tree.lua/lua/nvim-tree/actions/dispatch.lua#/--%20Tree%20modifiers



-- ─   Nvim tree helper functions                        ■

-- maps: ~/.config/nvim/plugin/file-manage.vim#/nnoremap%20<silent>%20<leader>nf
-- highlights: ~/.config/nvim/colors/munsell-blue-molokai.vim#/Nvim%20Tree


function _G.Tree_cursorPath()
  local node = tree.get_node_under_cursor()
  return node.absolute_path
end
-- Tree_cursorPath()  

function _G.TreeOpen()
  tree.open({ current_window = true, find_file = true, })
end
-- TreeOpen()  

function _G.Tree_focusPathInRootPath( focusPath, rootPath )
  -- vim.fn.AlternateFileLoc_save()
  tree.open({ path = rootPath, current_window = true })
  tree.find_file({ buf = focusPath })
  -- When opening nvt in the current_window, don't fix the windows size to allow normal vnew / new splits
  vim.opt.winfixwidth = false
  vim.opt.winfixheight = false
end

function _G.Tree_expandFolderInRootPath( focusPath, rootPath )
  Tree_focusPathInRootPath( focusPath, rootPath )
  node.open.no_window_picker()
end

function _G.Tree_setRootToCwd_keepFocuedNode()
  local focusPath = tree.get_node_under_cursor().absolute_path
  tree.change_root( vim.fn.getcwd(-1) )  -- the -1 option retrieves the global cwd while n-tree auto sets a local cwd. 
  tree.find_file({ buf = focusPath })
end


function _G.Tree_test()
  local tempFile = vim.fn.tempname()
  vim.fn.writefile( {'hi there'}, tempFile )
  -- vim.fn.delete( tempFile )
  require("nvim-tree.view").abandon_current_window()
  tree.close()
  vim.cmd("keepjumps edit " .. vim.fn.fnameescape( tempFile ))
end

-- vim.fn.fnamemodify('~/Documents/eins.txt', ":h")


function find_directory_and_focus()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function open_nvim_tree(prompt_bufnr, _)
    actions.select_default:replace(function()
      local api = require("nvim-tree.api")

      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      api.tree.open()
      api.tree.find_file(selection.cwd .. "/" .. selection.value)
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
  })
end


local tree_setBaseDir = function()
  local api = require("nvim-tree.api")
  -- local dir = vim.fn.expand('%:p:h')
  local dir = tree_lib.get_node_at_cursor().absolute_path
  -- put( dir )
  api.tree.change_root(dir)
end

local tree_openFolderDirvish = function()
  -- local api = require("nvim-tree.api")
  local dir = tree_lib.get_node_at_cursor().absolute_path
  vim.cmd "wincmd p"
  vim.cmd.edit( dir )
end

local tree_viewPathInPrevWin = function()
  -- local api = require("nvim-tree.api")
  local dir = tree_lib.get_node_at_cursor().absolute_path
  vim.cmd 'wincmd p'
  vim.cmd.edit( dir )
  vim.cmd "wincmd p"
end

local tree_NewBuf_fromNode = function( direction )
  local path = tree_lib.get_node_at_cursor().absolute_path
  vim.cmd "wincmd p"  -- Note the new-buf cmd will be applied to the previously visited windown
  vim.cmd "wincmd p"
end

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function open_tab_silent(node)
  local api = require("nvim-tree.api")
  api.node.open.tab(node)
  vim.cmd.tabprev()
end


-- command! -nargs=1 DirvishFloat1 call Dirvish_Float( <args> )
vim.cmd("command! -nargs=1 NvimTreeRevealFile lua NvimTree_find_file( <args> )")



-- ─^  Nvim tree helper functions                        ▲



-- ─   NvimTree config                                   ■

Nvim_tree = require("nvim-tree").setup({
  -- sort_by = "case_sensitive",
  hijack_netrw = false,
  git = {
    enable = true,
  },
  on_attach = on_attach,
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    -- highlight_modified = "name",
    indent_width = 2,
    root_folder_label = tree_root_folder_label,
    icons = {
      padding = " ",
      show = {
        file = true,
        git = true,
        folder = false,
        folder_arrow = false,
      },
      glyphs = {
        bookmark = "⠰",
        git = {
          unstaged = "₊",
          -- unstaged = "",
          staged = "ˆ",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    }
  },
  diagnostics = {
    enable = false,
    -- show_on_dirs = true,
    -- show_on_open_dirs = true,
    debounce_delay = 300,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  hijack_directories = {
    enable = false,
  },
  hijack_cursor = false,
  filters = {
    dotfiles = false,
  },
  -- update_focused_file = { -- ok this "follows" the current buffer! only want this per keystore/on demand
  --   enable = true,
  --   update_root = true,
  -- },
  sync_root_with_cwd = false,
  view = {
    width = function() return 30 end,
    preserve_window_proportions = false,
  },
  -- view = {
  --   float = {
  --     enable = true,
  --     quit_on_focus_loss = false,
  --   }
  -- },
  actions = {
    change_dir = { enable = false },
    expand_all = {
      max_folder_discovery = 5,
      exclude = { '.bloop', '.bsp', '.git', '.metals', 'archive', 'dbdumps', 'project', 'r', 'target', 'temp' }
    },
  },
  notify = {
    threshold = vim.log.levels.ERROR,
  },
  select_prompts = true,
  -- update_focused_file = {
  -- enable = true,
  -- update_root = true,
  -- ignore_list = {},
  -- },
})


-- ─^  NvimTree config                                   ▲







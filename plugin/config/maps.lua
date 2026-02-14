

vim.defer_fn(function()

  vim.diagnostic.config({
    virtual_text = {
      -- prefix = 'ᐤ',
      prefix = '•',
      format = function(diagnostic)

        local message = diagnostic.message

        if message:match("is assigned a value but never used") then return "" end
        if message:match("Line with spaces only.") then return "" end
        if message:match("is of type 'unknown'") then return "" end
        if message:match("implicitly has an 'any' type") then return "" end
     
        return message
      end
    }
  })

end, 1000)



-- ─   General maps                                      ■

-- PUT CLIPBOARD and jump back to put start cursor position.
-- Replace ~/.config/nvim/plugin/config/setup-general.vim‖/nmapˍpˍ<Plug>G_EasyClipPas
vim.keymap.set('n', 'p', function()
  local cursor_pos = vim.fn.getpos('.')
  vim.cmd('normal! p')
  vim.fn.setpos('.', cursor_pos)
end, { noremap = true, silent = true, desc = 'Paste without moving cursor' })

vim.keymap.set('n', 'P', function()
  local cursor_pos = vim.fn.getpos('.')
  vim.cmd('normal! P')
  vim.fn.setpos('.', cursor_pos)
end, { noremap = true, silent = true, desc = 'Paste before cursor without moving' })

vim.keymap.set('n', '<leader><leader>c<leader>', function()
  local cursor_pos = vim.fn.getpos('.')
  vim.cmd('ClearSpaces')
  -- vim.cmd('%s/\r//g')
  vim.fn.setpos('.', cursor_pos)
end, { noremap = true, silent = true, desc = 'Clear trailing spaces and empty lines' })

-- CLEAR SPACES. Delete spaces at the end of the line. Also delete spaces if spaces are the only characters in a line.
vim.api.nvim_create_user_command(
  'ClearSpaces',
  function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Remove trailing whitespace at the end of lines
    vim.cmd([[%s/\s\+$//e]])
    -- Remove lines containing only whitespace
    vim.cmd([[%s/^\s\+$//e]])

    vim.cmd('%s/\r//g')

    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    print("Spaces cleared")
  end,
  { desc = 'Remove trailing spaces and lines with only spaces' }
)

vim.keymap.set('o', '<leader>BG', function()
  print('Testing section selection')
  require('nvim-treesitter.textobjects.select').select_textobject('@heading.inner')
  -- require('nvim-treesitter.textobjects.select').select_textobject('@section.outer')
end, { buffer = false, desc = 'Test section selection' })


-- ─^  General maps                                      ▲


-- ─   Lsp defaults                                      ■

-- for lua files for some reason this doesn't seem to work as buffer maps.
vim.keymap.set('n', 'gel', function()
  Telesc_launch('lsp_document_symbols')
end, { noremap = true, silent = true, desc = 'LSP document symbols' })

vim.keymap.set('n', 'geL', function()
  Telesc_launch('lsp_dynamic_workspace_symbols')
end, { noremap = true, silent = true, desc = 'LSP workspace symbols' })


-- nnoremap <silent><buffer> gsl :call v:lua.Telesc_launch('lsp_document_symbols')<cr>





-- ─^  Lsp defaults                                      ▲




local opts_1 = { initial_mode = 'normal' }
local opts_2 = {
  sorting_strategy = 'ascending',
  -- default_text = [[(Seq|List)]],
}


local dir_a_scala3 = '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/'
local dir_nvim = [[/Users/at/.config/nvim/plugin]]
local dirs_nvim = { [[/Users/at/.config/nvim/plugin]], [[/Users/at/.config/nvim/lua]]}

local rgx_caps_tag = [[\s[A-Z]{3,}:]]
local rgx_comment = [[^(\s*)?(//|\*\s)]]
local rgx_main_symbol = [[(def\s|case\sclass|enum\s|val\s[^e])]]
local rgx_main_symbol_vimLua = [[^(func|local\sfunction|command!)]]
-- local rgx_keymap_vimlua = [[keymap.*\n.*\n]]
local rgx_keymap_vim = [[((noremap\s|map\s)|keymap.*\n.*\n)]]
local rgx_header = [[─\s.*]]
-- local rgx_signature = [[(def|extension).*(\n)?.*(\n)?.*(\n)?.*\s=\s]]
-- local rgx_signature = [[(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=\s]]
-- local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=(\s|$)).*(List|Seq)]]
-- local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*(\n)?.*(\n)?.*\s=\s).*(List|Seq|Iterable)]]
local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=\s)]]
local rgx_collection = [[(List|Seq|Iterable)]]

-- local glb_projs1 = {
--   '-g', '**/AZioHttp/*.scala',
--   '-g', '**/BZioHttp/*.scala'
-- }

-- local glb_patterns1 = {
--   '-g', '**/*pattern*.scala',
--   '-g', '**/*utils*.scala',
-- }

local glb_vim = {
  '-g', '**/plugin/*.vim',
  '-g', '**/plugin/*.lua',
  '-g', '**/lua/*.lua',
}

local paths_projs1 = {
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/AZioHttp/',
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/',
}

local paths_patterns1 = {
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/',
}


-- ─   Outdated scala maps                               ■

-- function M.RgxSelect_Picker(opts, rgx_query, globs, paths)

-- now using regular live grep
-- ~/.config/nvim/plugin/utils-fileselect-telescope.vim#/Find%20files%20using
-- search in [A]ll scala code:
-- vim.keymap.set( 'n',
--   ',sa', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     "",
--     {"-g", "*.scala"},
--     {'.'}
--     ) end )

-- vim.keymap.set( 'n',
--   ',sA', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     "",
--     {"-g", "*.scala"},
--     {'/Users/at/Documents/Proj/b_expl_stack/'}
--     ) end )

-- vim.keymap.set( 'n',
--   ',sA', function() Telesc_launch( 'live_grep', {
--     initial_mode = 'insert',
--     -- default_text = pattern,
--     search_dirs = {'/Users/at/Documents/Proj/b_expl_stack/'},
--   } )
--   end, { desc = 'Live grep in stack project' })


-- vim.keymap.set( 'n',
--   ',sA', function() Telesc_launch( 'live_grep', {
--     initial_mode = 'insert',
--     -- default_text = pattern,
--     search_dirs = {'/Users/at/Documents/Proj/b_expl_stack/'},
--   } )
--   end, { desc = 'Live grep in stack project' })


-- -- search in scala [S]ymbols:
-- -- (also note gel for the lsp symbols in the current file)
-- vim.keymap.set( 'n',
--   ',ss', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_main_symbol,
--     {"-g", "*.scala"},
--     {'.'}
--     ) end, { desc = 'Search Scala symbols in current dir' })

-- vim.keymap.set( 'n',
--   ',sS', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_main_symbol,
--     {"-g", "*.scala"},
--     {'/Users/at/Documents/Proj/b_expl_stack/'}
--     ) end, { desc = 'Search Scala symbols in stack project' })

-- -- search in [A]ll scala code:
-- vim.keymap.set( 'n',
--   'ge;', function() require( 'utils.general' )
--     .RgxSelect_Picker( {},
--       "",
--       {"-g", "*.scala"},
--       {'.'}
--     ) end, { desc = 'Search all Scala code in current dir' })

-- vim.keymap.set( 'n',
--   'ge:', function() require( 'utils.general' )
--     .RgxSelect_Picker( {},
--       "",
--       {"-g", "*.scala"},
--       {'/Users/at/Documents/Proj/b_expl_stack/'}
--     ) end, { desc = 'Search all Scala code in stack project' })

-- -- search in comment TAGS:
-- vim.keymap.set( 'n',
--   ',st', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_caps_tag,
--     {},
--     {'.'}
--     ) end, { desc = 'Search comment tags in current dir' })

-- vim.keymap.set( 'n',
--   ',sT', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_caps_tag,
--     glb_projs1,
--     {'..'}
--     ) end, { desc = 'Search comment tags in parent dir' })


-- ─^  Outdated scala maps                               ▲



-- search in COMMENTS:
-- vim.keymap.set( 'n',
--   ',sc', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_comment,
--     {},
--     {'.'}
--     ) end )

-- vim.keymap.set( 'n',
--   ',sC', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_comment,
--     glb_projs1,
--     {'..'}
--     ) end )

-- search in HEADERS:
vim.keymap.set( 'n',
  ',sh', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_header,
    {},
    {'.'}
    ) end, { desc = 'Search headers in current dir' })

vim.keymap.set( 'n',
  ',sH', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_header,
    glb_projs1,
    {'..'}
    ) end, { desc = 'Search headers in parent dir' })

-- search in SIGNATURES:
vim.keymap.set( 'n',
  ',sg', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    {},
    {'.'}
    ) end, { desc = 'Search signatures in current dir' })

vim.keymap.set( 'n',
  ',sG', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    glb_patterns1,
    {'..'}
    ) end, { desc = 'Search signatures in patterns' })

vim.keymap.set( 'n',
  ',si', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature .. '.*' .. rgx_collection,
    glb_projs1,
    {'..'}
    ) end, { desc = 'Search signatures with collections' })

vim.keymap.set( 'n',
  ',sz', function() require( 'utils.general' )
  .RgxSelect_Picker( opts_2,
    rgx_signature .. '.*?' .. [[ZIO]],
    glb_projs1,
    {'..'}
    ) end, { desc = 'Search signatures with ZIO' })

-- ─   Git picker maps                                  ──
-- NOTE these maps: ~/.config/nvim/plugin/utils/utils-git.vim‖*GitˍTools

-- vim.keymap.set( 'n',
--   '<leader>ogs', function()
--     require'git_commits_viewer'.Show(5)
--   end )

-- vim.keymap.set( 'n',
--   '<leader>ogl', function()
--     require'git_commits_viewer'.Show(10)
--   end )

-- Note: <leader>ogL is now replaced by <leader>gC (see below)
-- Keeping it as a legacy alias for muscle memory
vim.keymap.set( 'n',
  '<leader>ogL', function()
    require'git_commits_viewer'.Show( { num_of_commits = 40 } )
  end, { desc = '[Legacy] Use <leader>gC instead - Git commits viewer (40)' })

-- Telescope-based git commit picker (alternative to git_commits_viewer)
opts_gitstat = {
  layout_config = {
    height=0.99,
    width=0.82,
    horizontal = {
      preview_width = 0.6,  -- Takes up 60% of the window width
    },
    vertical = {
      preview_height = 0.8,  -- Takes up 70% of the window height
    },
  },
  initial_mode='normal',
}

vim.keymap.set( 'n',
  '<leader>ogl', function() require( 'utils.general' )
  .Git_commits_picker( opts_gitstat )
  end, { desc = 'Telescope: Git commits picker' })

-- vim.keymap.set( 'n',
--   '<leader>ogl', function()
--     require'git_commits_viewer'.Show()
--   end )



-- NOTE: gg.. maps conflict with gg - go to top of page!
-- vim.keymap.set( 'n',
--   'ggl', function() require( 'utils.general' )
--   .Git_commits_picker( opts_gitstat, vim.fn.expand('%') )
--   end )

-- vim.keymap.set( 'n',
--   'ggL', function() require( 'utils.general' )
--   .Git_commits_picker( opts_gitstat )
--   end )


-- DiffviewFileHistory shows new code blocks in the normal editor with normal syntax highlight.
vim.keymap.set('n', '<leader><leader>ogl', ':DiffviewFileHistory %<CR>', { noremap = true, silent = true, desc = "Open Git log for current file" })
vim.keymap.set('n', '<leader><leader>ogL', ':DiffviewFileHistory -C .<CR>',   { noremap = true, silent = true, desc = "Open Git log: Involved files per commit." })



-- vim.keymap.set( 'n',
--   '<leader>ogs', function() require( 'utils.general' )
--   .Git_status_picker( opts_1 )
--   end )


-- vim.keymap.set( 'n',
--   '<leader>ogs', function() require( 'utils.general' )
--   .Git_status_picker( opts_gitstat )
--   end )

-- vim.keymap.set( 'n',
--   'ggs', function() require( 'utils.general' )
--   .Git_status_picker( opts_gitstat )
--   end )


-- no nice styling of diffs
vim.keymap.set( 'n',
  '<leader>ogS', function() Telesc_launch( 'git_status', {
    initial_mode = 'normal',
    cwd = vim.fn.getcwd( vim.fn.winnr() ),
  } )
  end, { desc = 'Git status with Telescope' })

-- no nice styling of diffs
-- vim.keymap.set( 'n',
--   'ggS', function() Telesc_launch( 'git_status', {
--     initial_mode = 'normal',
--     cwd = vim.fn.getcwd( vim.fn.winnr() ),
--   } )
--   end )

-- ─   Git Commits & History                             ■

-- Git Commits viewer (c = commits)
vim.keymap.set( 'n',
  '<leader>gc', function()
   require'git_commits_viewer'.Show({ num_of_commits = 8 })
  end, { desc = "Git commits viewer (8 commits)" } )

vim.keymap.set( 'n',
  '<leader>gC', function()
   require'git_commits_viewer'.Show({ num_of_commits = 40 })
  end, { desc = "Git commits viewer (40 commits)" } )

-- Git File history (f = file)
vim.keymap.set( 'n',
  '<leader>gf', function()
   require'git_commits_viewer'.ShowCurrentFile(15)
  end, { desc = "Git file history (current file, 15 commits)" } )

vim.keymap.set( 'n',
  '<leader>gF', function()
   require'git_commits_viewer'.ShowCurrentFile(40)
  end, { desc = "Git file history (current file, 40 commits)" } )

-- ─^  Git Commits & History                             ▲


-- ─   Git Diff Operations                               ■

-- Toggle diff overlay (dd = diff display, most common operation)
vim.keymap.set( 'n',
  '<leader>gdd', function()
    MiniDiff.toggle_overlay()
  end, { desc = 'Toggle git diff overlay (inline)' })

-- Compare two files from consecutive lines (df = diff files)
vim.keymap.set( 'n',
  '<leader>gdf', function()
    local opts = {}
    opts.diff_file1 = vim.split( vim.fn.GetPath_fromLine(), "‖", { plain = true })[1]  --  text before pipe
    vim.cmd'normal! j'
    opts.diff_file2 = vim.split( vim.fn.GetPath_fromLine(), "‖", { plain = true })[1]  --  text before pipe
    vim.cmd'normal! k'
   require'git_commits_viewer'.Show(opts)
  end, { desc = "Compare two files from consecutive lines (git diff --no-index)" } )

-- Compare two refs/branches from consecutive lines (db = diff branches)
vim.keymap.set( 'n',
  '<leader>gdb', function()
    local branch1 = vim.fn.getline('.')
    vim.cmd'normal! j'
    local branch2 = vim.fn.getline('.')
    vim.cmd'normal! k'
   require'git_commits_viewer'.ShowBranches(branch1, branch2)
  end, { desc = "Compare two git refs from consecutive lines (branches/commits/HEAD~1)" } )

-- Smart compare: auto-detect files/dirs vs git refs (dr = diff refs/paths)
vim.keymap.set( 'n',
  '<leader>gdr', function()
    -- Try extracting paths first
    local path1 = vim.split( vim.fn.GetPath_fromLine(), "‖", { plain = true })[1]
    vim.cmd'normal! j'
    local path2 = vim.split( vim.fn.GetPath_fromLine(), "‖", { plain = true })[1]
    vim.cmd'normal! k'

    -- Check if both are valid paths (files or directories)
    local path1_is_file = vim.fn.filereadable(path1) == 1
    local path1_is_dir = vim.fn.isdirectory(path1) == 1
    local path2_is_file = vim.fn.filereadable(path2) == 1
    local path2_is_dir = vim.fn.isdirectory(path2) == 1

    if (path1_is_file or path1_is_dir) and (path2_is_file or path2_is_dir) then
      -- Both are valid paths
      if path1_is_dir and path2_is_dir then
        -- Both are directories → use directory diff mode with file list
        local opts = { diff_dir1 = path1, diff_dir2 = path2 }
        require'git_commits_viewer'.Show(opts)
      else
        -- At least one is a file → use simple file diff mode
        local opts = { diff_file1 = path1, diff_file2 = path2 }
        require'git_commits_viewer'.Show(opts)
      end
    else
      -- Not valid paths → treat as git refs
      local ref1 = vim.fn.getline('.')
      vim.cmd'normal! j'
      local ref2 = vim.fn.getline('.')
      vim.cmd'normal! k'
      require'git_commits_viewer'.ShowBranches(ref1, ref2)
    end
  end, { desc = "Smart compare: auto-detect files/dirs vs git refs from consecutive lines" } )

-- ─^  Git Diff Operations                               ▲


-- ─   Branch Comparisons (localleader)                  ■

-- Helper function to determine current branch based on cwd
local function get_current_branch_from_cwd()
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ':t')

  if project_name:match('_claude$') then
    return 'agent/claude'
  elseif project_name:match('_codex$') then
    return 'agent/codex'
  elseif project_name:match('_gemini$') then
    return 'agent/gemini'
  else
    -- Get actual current branch
    local branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
    return branch
  end
end

vim.keymap.set( 'n',
  '<localleader>gm', function()
    local current_branch = get_current_branch_from_cwd()
    print( current_branch )
    require'git_commits_viewer'.ShowBranches('main', current_branch)
  end, { desc = "Compare current branch with main" } )

vim.keymap.set( 'n',
  '<localleader>gc', function()
    local current_branch = get_current_branch_from_cwd()
    require'git_commits_viewer'.ShowBranches(current_branch, 'agent/claude')
  end, { desc = "Compare current branch with agent/claude" } )

vim.keymap.set( 'n',
  '<localleader>go', function()
    local current_branch = get_current_branch_from_cwd()
    require'git_commits_viewer'.ShowBranches(current_branch, 'agent/codex')
  end, { desc = "Compare current branch with agent/codex" } )

vim.keymap.set( 'n',
  '<localleader>gg', function()
    local current_branch = get_current_branch_from_cwd()
    require'git_commits_viewer'.ShowBranches(current_branch, 'agent/gemini')
  end, { desc = "Compare current branch with agent/gemini" } )

-- ─^  Branch Comparisons (localleader)                  ▲


-- ─   Gitsigns - Diff with N commits ago                ■

-- Maps:
-- l gh    - Gitsigns change_base ~1
-- l gH    - Gitsigns change_base
-- l g1    - Gitsigns change_base ~1
-- l g2    - Gitsigns change_base ~2
-- l g3    - Gitsigns change_base ~3



vim.keymap.set('n', '<leader>gh', ':Gitsigns change_base ~1<CR>:MiniDiffAgainst HEAD~1<cr>', { noremap = true, silent = true, desc = 'Git diff with 1 commit ago' })
vim.keymap.set('n', '<leader>gH', ':Gitsigns change_base<CR>:MiniDiffAgainst HEAD<cr>', { noremap = true, silent = true, desc = 'Git diff with base' })
vim.keymap.set('n', '<leader>g1', ':Gitsigns change_base ~1<CR>:MiniDiffAgainst HEAD~1<cr>', { noremap = true, silent = true, desc = 'Git diff with 1 commit ago' })
vim.keymap.set('n', '<leader>g2', ':Gitsigns change_base ~2<CR>:MiniDiffAgainst HEAD~2<cr>', { noremap = true, silent = true, desc = 'Git diff with 2 commits ago' })
vim.keymap.set('n', '<leader>g3', ':Gitsigns change_base ~3<CR>:MiniDiffAgainst HEAD~3<cr>', { noremap = true, silent = true, desc = 'Git diff with 3 commits ago' })
vim.keymap.set('n', '<leader>g4', ':Gitsigns change_base ~4<CR>:MiniDiffAgainst HEAD~4<cr>', { noremap = true, silent = true, desc = 'Git diff with 4 commits ago' })
vim.keymap.set('n', '<leader>g5', ':Gitsigns change_base ~5<CR>:MiniDiffAgainst HEAD~5<cr>', { noremap = true, silent = true, desc = 'Git diff with 5 commits ago' })


-- ─^  Gitsigns                                          ▲

vim.keymap.set( 'n',
  '<leader>ogd', function() require( 'utils.general' )
  .Git_diff_to_master( opts_1 )
  end, { desc = 'Git diff to master' })

-- search in VIM_MAIN_SYMBOLS:
vim.keymap.set( 'n',
  ',svs', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_main_symbol_vimLua,
    {},
    dirs_nvim
    ) end, { desc = 'Search Vim/Lua symbols' })


-- search in VIM_KEYMAPS:
vim.keymap.set( 'n',
  ',svm', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_keymap_vim,
    {},
    dirs_nvim
    ) end, { desc = 'Search Vim keymaps' })


-- search in entire vim code:
vim.keymap.set( 'n',
  ',svv', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    "",
    {},
    dirs_nvim
    ) end, { desc = 'Search all Vim config' })

-- search in entire vim headers:
vim.keymap.set( 'n',
  ',svh', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_header,
    {},
    dirs_nvim
    ) end, { desc = 'Search Vim headers' })

-- search in VIM_HELP:
vim.keymap.set( 'n',
  '<leader>gsH', function()
  Telesc_launch( 'help_tags', {
    default_text = vim.fn.expand '<cword>',
    initial_mode = 'normal',
  } ) end, { desc = 'Search help tags for word under cursor' })


function vim.getVisualSelection()
   vim.cmd('noau normal! "vy"')
   local text = vim.fn.getreg('v')
   vim.fn.setreg('v', {})
   text = string.gsub(text, "\n", "")
   if #text > 0 then
       return text
   else
       return ''
   end
end


vim.keymap.set( 'v',
  '<leader>gsh', function()
  Telesc_launch( 'help_tags', {
    default_text = vim.getVisualSelection(),
    initial_mode = 'normal',
  } ) end, { desc = 'Search help tags for visual selection' })



-- local file_ignore_patterns = {
--   '^.git/', '^target/', '^node%_modules/', '^.npm/', '^modules', 'dev.js', '^build/', '%[Cc]ache/', '%-cache',
--   '^scala-doc/',
--   '%.sql', '%.tags', 'tags', '%.gemtags',
-- }


-- Just the oldfiles map
-- vim.keymap.set( 'n',
--   'gp', function() require( 'telescope.builtin' )
--     .oldfiles(
--       {
--         file_ignore_patterns = file_ignore_patterns
--       }
--     ) end )








local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

local theme_opts = {
    -- theme = "cursor",
    sorting_strategy = "ascending",
    results_title = false,
    layout_strategy = "cursor",
    layout_config = { width = 0.95, height = 25 },
  }

-- vim.keymap.set( 'n', 'ger',        function() builtin.lsp_references(themes.get_cursor()) end )
vim.keymap.set( 'n', '<leader>fr', function() builtin.lsp_references(themes.get_cursor( theme_opts )) end, { desc = 'Find LSP references' })
-- require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor())


-- ─   Style & color maps                               ──
-- Note: ~/.config/nvim/init.vim‖/is_dark_modeˍ==ˍ1

vim.keymap.set( 'n',
  ',,cl', function()
    vim.cmd'colorscheme munsell-blue-molokai_light_1'
    vim.g.is_dark_mode = 0  -- Update the global variable
    -- New terminals will automatically use the light theme
    Set_alacritty_bg('E3E6E9')
    vim.cmd('luafile ~/.config/nvim/plugin/config/tabline_tabby.lua')
    -- Clear neotree's cached numbered highlight groups and redraw
    pcall(function()
      -- Clear all numbered NeoTree highlight variants (e.g., NeoTreeFileName_60)
      for _, hl in ipairs(vim.fn.getcompletion('NeoTree', 'highlight')) do
        if hl:match('_%d+$') then
          vim.cmd('highlight clear ' .. hl)
        end
      end
      -- Redraw neotree windows
      local manager = require('neo-tree.sources.manager')
      local renderer = require('neo-tree.ui.renderer')
      for _, state in pairs(manager.get_states()) do
        renderer.redraw(state)
      end
    end)
  end, { desc = 'Switch to light theme' })

vim.keymap.set( 'n',
  ',,cd', function()
    -- TODO: the dark theme seems to miss setting the tabs background
    vim.cmd'colorscheme munsell-blue-molokai'
    vim.g.is_dark_mode = 1  -- Update the global variable
    -- New terminals will automatically use the dark theme
    Set_alacritty_bg('151719')
    vim.cmd('luafile ~/.config/nvim/plugin/config/tabline_tabby.lua')
    -- Clear neotree's cached numbered highlight groups and redraw
    pcall(function()
      -- Clear all numbered NeoTree highlight variants (e.g., NeoTreeFileName_60)
      for _, hl in ipairs(vim.fn.getcompletion('NeoTree', 'highlight')) do
        if hl:match('_%d+$') then
          vim.cmd('highlight clear ' .. hl)
        end
      end
      -- Redraw neotree windows
      local manager = require('neo-tree.sources.manager')
      local renderer = require('neo-tree.ui.renderer')
      for _, state in pairs(manager.get_states()) do
        renderer.redraw(state)
      end
    end)
  end, { desc = 'Switch to dark theme' })


-- ─   Lsp maps                                         ──
-- also at:
-- ~/.config/nvim/plugin/tools_scala.vim#/Lsp%20maps

-- vim.keymap.set( 'n',
--   'gD', function()
--     vim.lsp.buf.declaration()
--   end )

vim.keymap.set( 'n',
  ']d', function()
    vim.diagnostic.goto_next()
  end, { desc = 'Go to next diagnostic' })

vim.keymap.set( 'n',
  '[d', function()
    vim.diagnostic.goto_prev()
  end, { desc = 'Go to previous diagnostic' })


-- note I'm overriding this in python.vim to use lspimport
vim.keymap.set( 'n',
  '<leader>cA', function()
    vim.lsp.buf.code_action()
  end, { desc = 'LSP code action' })

-- this uses Plug 'stevanmilic/nvim-lspimport' specifically for pyright
vim.keymap.set( 'n',
  '<leader>ca',
  require("lspimport").import,
  { desc = 'Auto import with lspimport' }
)




  -- buf_map(bnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- -- buf_map(bnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- -- now in /Users/at/.config/nvim/plugin/setup-lsp.vim
  -- -- Now a buffer map in tools_rescript.vim
  -- -- buf_map(bnr, 'n', 'gek', '<cmd>lua vim.lsp.buf.hover()<CR>')
  -- buf_map(bnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- buf_map(bnr, 'n', '<space><space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- buf_map(bnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- buf_map(bnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- buf_map(bnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  -- buf_map(bnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  -- buf_map(bnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- buf_map(bnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- -- Now a buffer map in tools_rescript.vim
  -- -- buf_map(bnr, 'n', 'ger', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- buf_map(bnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  -- buf_map(bnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  -- buf_map(bnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  -- buf_map(bnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  -- buf_map(bnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  -- buf_map(bnr, 'n', '<space>?', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]

  -- vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  -- vim.cmd("command! LspDocSymbols lua require('telescope.builtin').lsp_document_symbols()")
  -- vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  -- vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  -- vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  -- vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  -- vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  -- vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  -- vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  -- vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  -- vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  -- vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  -- vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")


-- ─   Project Notes                                    ■

-- Load project notes module
local project_notes = require('utils.project_notes')

vim.keymap.set('n', '<leader>nv', function() project_notes.openNotes("vsplit ") end,
  { desc = 'Open project notes (vsplit)' })

vim.keymap.set('n', '<leader>ni', function() project_notes.openNotes("edit") end,
  { desc = 'Open project notes (vsplit)' })

vim.keymap.set('n', '<leader>ns', function() project_notes.openNotes("split ") end,
  { desc = 'Open project notes (split)' })

-- Open project notes in new tab
vim.keymap.set('n', '<leader>nT', project_notes.openNotesTab,
  { desc = 'Open project notes (tab)' })

-- Open project notes directory
vim.keymap.set('n', '<leader>nd', project_notes.openNotesProjDir,
  { desc = 'Open project notes directory' })

-- Open notes proj directory
vim.keymap.set('n', '<leader>nD', project_notes.openNotesProjDir,
  { desc = 'Open notes proj directory' })

-- Browse notes proj directory
vim.keymap.set('n', '<leader>nf', project_notes.browseNotes,
  { desc = 'Browse notes proj directory' })

-- Create new / "touch" note in project folder
vim.keymap.set('n', '<leader>nt', project_notes.createNote,
  { desc = 'Create new project note' })

-- Find notes using telescope
-- vim.keymap.set('n', '<c-w>ps', project_notes.findNotes,
--   { desc = 'Find project notes' })

-- ─^  Project Notes                                    ▲


-- ─   Google Docs sync with markdown                    ■

local gdoc_sync = require('gdoc_sync').setup({
   push_key = '<leader><leader>dp',
   pull_key = '<leader><leader>df',
   list_key = '<leader><leader>dl',
})

vim.keymap.set('n', '<leader><leader>dl', gdoc_sync.list,
  { desc = 'List recent Google Docs' })

-- TODO / planned feature:
-- Fetch recent google docs to a buffer (like in lua/git_commits_viewer.lua)
-- using keymaps loading docs into the cwd?

-- ─^  Google Docs sync with markdown                    ▲


-- ─   Claude Code paste cleanup                         ■

require('utils.cc_paste').setup({ key = '<leader>cV' })

-- ─^  Claude Code paste cleanup                         ▲



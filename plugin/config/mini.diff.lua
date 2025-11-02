
-- https://github.com/echasnovski/mini.diff
-- help MiniDiff

-- NOTE these maps: 
-- ~/.config/nvim/plugin/config/maps.lua‖*Gitsigns
-- ~/.config/nvim/plugin/config/maps.lua‖*Gitˍpickerˍmaps
-- ~/.config/nvim/plugin/utils/utils-git.vim‖*GitˍTools

local minidiff = require'mini.diff'

-- No need to copy this inside `setup()`. Will be used automatically.
local conf = {
  -- Options for how hunks are visualized
  view = {
    -- Visualization style. Possible values are 'sign' and 'number'.
    -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
    -- style = vim.go.number and 'number' or 'sign',
    style = 'number',

    -- Signs used for hunks with 'sign' view
    signs = { add = '▒', change = '▒', delete = '▒' },

    -- Priority of used visualization extmarks
    priority = 199,
  },

  -- Source for how reference text is computed/updated/etc
  -- Uses content from Git index by default
  source = nil,

  -- Delays (in ms) defining asynchronous processes
  delay = {
    -- How much to wait before update following every text change
    text_change = 200,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = 'gh',

    -- Reset hunks inside a visual/operator region
    reset = 'gH',

    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = 'gh',

    -- Go to hunk range in corresponding direction
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },

  -- Various options
  options = {
    -- Diff algorithm. See `:h vim.diff()`.
    algorithm = 'histogram',

    -- Whether to use "indent heuristic". See `:h vim.diff()`.
    indent_heuristic = true,

    -- The amount of second-stage diff to align lines (in Neovim>=0.9)
    linematch = 60,

    -- Whether to wrap around edges during hunk navigation
    wrap_goto = false,
  },
}

minidiff.setup( conf )

vim.api.nvim_create_user_command('MiniDiffAgainst', function(opts)
  local file = vim.fn.expand('%:~:.')
  local ref  = vim.fn.systemlist({'git', 'show', opts.args .. ':' .. file})
  if vim.v.shell_error == 0 then require('mini.diff').set_ref_text(0, ref) end
end, { nargs = 1 })

-- ─   File History Navigation                             ■

-- Get commits that changed the current file
local function get_file_commit_history()
  local file = vim.fn.expand('%:p')
  if file == '' then return nil end

  -- Get commit hashes where this file actually changed
  local commits = vim.fn.systemlist({'git', 'log', '--follow', '--format=%H', '--', file})

  if vim.v.shell_error ~= 0 or #commits == 0 then
    return nil
  end

  return commits
end

-- Show diff between consecutive commits in file history
local function show_file_history_diff(direction)
  local commits = get_file_commit_history()

  if not commits then
    print("No git history found for this file")
    return
  end

  -- Get or initialize position (0 = showing HEAD vs previous change)
  local pos = vim.b.file_history_pos or 0

  -- Save original buffer content on first use
  if not vim.b.file_history_original_content then
    vim.b.file_history_original_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end

  -- Update position
  if direction == 'back' then
    pos = pos + 1
  elseif direction == 'forward' then
    pos = math.max(0, pos - 1)
  end

  -- Boundary check
  if pos >= #commits - 1 then
    pos = #commits - 2
    print("Already at oldest file change")
  end

  if pos < 0 then
    pos = 0
    print("Already at newest (HEAD)")
  end

  -- Store position
  vim.b.file_history_pos = pos

  -- Get the two commits to compare
  local newer_commit = commits[pos + 1]  -- The "after" state
  local older_commit = commits[pos + 2]  -- The "before" state

  local file = vim.fn.expand('%:~:.')

  -- Get content from both commits
  local newer_content = vim.fn.systemlist({'git', 'show', newer_commit .. ':' .. file})
  local older_content = vim.fn.systemlist({'git', 'show', older_commit .. ':' .. file})

  if vim.v.shell_error ~= 0 then
    print("Error: Could not retrieve file content from commits")
    return
  end

  -- Load the newer commit content into buffer (showing what changed IN that commit)
  local modifiable = vim.bo.modifiable
  vim.bo.modifiable = true
  vim.api.nvim_buf_set_lines(0, 0, -1, false, newer_content)
  vim.bo.modifiable = modifiable
  vim.bo.modified = false

  -- Set older commit as reference (to show diff)
  require('mini.diff').set_ref_text(0, older_content)

  -- Show status
  local status = string.format(
    "File history: -%d/%d (changes in %s vs %s)",
    pos,
    #commits - 1,
    newer_commit:sub(1,7),
    older_commit:sub(1,7)
  )
  print(status)

  -- Jump to first hunk after a brief delay (let diff calculate)
  vim.defer_fn(function()
    -- Try to jump to first hunk
    local ok = pcall(function()
      require('mini.diff').goto_hunk('first')
    end)
    if not ok then
      -- If no hunks found, stay at current position
      print(status .. " (no changes visible)")
    end
  end, 50)
end

-- Reset to HEAD comparison
local function reset_file_history()
  vim.b.file_history_pos = nil

  -- Restore original buffer content if saved
  if vim.b.file_history_original_content then
    local modifiable = vim.bo.modifiable
    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.b.file_history_original_content)
    vim.bo.modifiable = modifiable
    vim.b.file_history_original_content = nil
  end

  -- Get HEAD content to reset to default comparison
  local file = vim.fn.expand('%:~:.')
  local head_content = vim.fn.systemlist({'git', 'show', 'HEAD:' .. file})

  if vim.v.shell_error == 0 then
    require('mini.diff').set_ref_text(0, head_content)
    print("Reset to HEAD comparison")
  else
    -- If file doesn't exist in HEAD (new file), disable/enable to reset
    require('mini.diff').disable(0)
    require('mini.diff').enable(0)
    print("Reset to default (file may be new)")
  end
end

-- Keymaps
vim.keymap.set('n', '<leader>g[', function() show_file_history_diff('back') end,
  { noremap = true, silent = true, desc = 'Step back in file change history' })

vim.keymap.set('n', '<leader>g]', function() show_file_history_diff('forward') end,
  { noremap = true, silent = true, desc = 'Step forward in file change history' })

vim.keymap.set('n', '<leader>g0', reset_file_history,
  { noremap = true, silent = true, desc = 'Reset to HEAD comparison' })

-- ─^  File History Navigation                             ▲

